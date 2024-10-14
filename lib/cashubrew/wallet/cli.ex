defmodule Cashubrew.Wallet.CLI do
  @moduledoc """
  A simple CLI wallet for interacting with the Cashubrew mint.
  """

  alias Cashubrew.Nuts.Nut00.{BDHKE, BlindedMessage, Proof}
  alias Cashubrew.Wallet
  require Logger

  defp mint_url do
    "http://localhost:4000/api/v1"
  end

  defp data_dir do
    "./_build/.cashubrew/data"
  end

  defp proof_file do
    "proofs.json"
  end

  def main(args) do
    case args do
      ["mint", amount_str] ->
        amount = String.to_integer(amount_str)
        mint_tokens(amount)

      ["balance"] ->
        show_balance()

      _ ->
        show_usage()
    end
  end

  defp show_usage do
    IO.puts("Usage:")
    IO.puts(~S|  mix run -e 'Cashubrew.Wallet.CLI.main(["mint", "<amount>"])'|)
    IO.puts(~S|  mix run -e 'Cashubrew.Wallet.CLI.main(["balance"])'|)
  end

  defp mint_tokens(amount) do
    IO.puts("Minting tokens...")
    wallet = Wallet.load_or_create_wallet()
    IO.puts("Wallet: #{inspect(wallet)}")

    with {:ok, quote} <- request_mint_quote(amount),
         {:ok, {blinded_messages, secrets, rs}} <- generate_blinded_messages(amount),
         {:ok, signatures} <- send_mint_request(quote["quote"], blinded_messages) do
      proofs = unblind_signatures(wallet, signatures, secrets, rs)
      store_proofs(proofs)
      IO.puts("Minted tokens successfully!")
      show_balance()
    else
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  defp request_mint_quote(amount) do
    url = "#{mint_url()}/mint/quote/bolt11"
    headers = [{"Content-Type", "application/json"}]
    body = Jason.encode!(%{"amount" => amount, "unit" => "sat"})

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 201, body: response_body}} ->
        {:ok, Jason.decode!(response_body)}

      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        {:error, "HTTP Error #{status_code}: #{response_body}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP Error: #{inspect(reason)}"}
    end
  end

  defp generate_blinded_messages(amount) do
    with {:ok, keyset_id} <- get_active_keyset_id() do
      amounts = split_amount(amount)
      secrets = Enum.map(amounts, fn _ -> :crypto.strong_rand_bytes(32) end)
      rs = Enum.map(amounts, fn _ -> BDHKE.generate_keypair() end)

      blinded_messages =
        Enum.zip([amounts, secrets, rs])
        |> Enum.map(fn {amt, secret, {r_priv, _r_pub}} ->
          {b_prime, _r} = BDHKE.step1_alice(secret, r_priv)

          %BlindedMessage{
            amount: amt,
            id: keyset_id,
            B_: Base.encode16(b_prime, case: :lower)
          }
        end)

      {:ok, {blinded_messages, secrets, rs}}
    end
  end

  defp get_active_keyset_id do
    url = "#{mint_url()}/keysets"
    headers = [{"Content-Type", "application/json"}]

    with {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} <-
           HTTPoison.get(url, headers),
         %{"keysets" => keysets} <- Jason.decode!(response_body),
         %{"id" => keyset_id} <- Enum.find(keysets, fn ks -> ks["active"] == true end) do
      {:ok, keyset_id}
    else
      nil ->
        {:error, "No active keyset found"}

      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        {:error, "HTTP Error #{status_code}: #{response_body}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP Error: #{inspect(reason)}"}
    end
  end

  defp send_mint_request(quote_id, blinded_messages) do
    url = "#{mint_url()}/mint/bolt11"
    headers = [{"Content-Type", "application/json"}]

    outputs =
      Enum.map(blinded_messages, fn bm ->
        %{
          "amount" => bm.amount,
          "id" => bm.id,
          "B_" => bm."B_"
        }
      end)

    body = Jason.encode!(%{"quote" => quote_id, "outputs" => outputs})

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        response = Jason.decode!(response_body)
        {:ok, response["signatures"]}

      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        {:error, "HTTP Error #{status_code}: #{response_body}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP Error: #{inspect(reason)}"}
    end
  end

  defp unblind_signatures(wallet, signatures, secrets, rs) do
    a_pub = Base.decode16!(wallet.public_key, case: :lower)

    Enum.zip([signatures, secrets, rs])
    |> Enum.map(fn {signature, secret, {r_priv, _r_pub}} ->
      c_prime = Base.decode16!(signature["C_"], case: :lower)
      c = BDHKE.step3_alice(c_prime, r_priv, a_pub)

      %Proof{
        amount: signature["amount"],
        id: signature["id"],
        secret: Base.encode16(secret, case: :lower),
        C: Base.encode16(c, case: :lower)
      }
    end)
  end

  defp store_proofs(proofs) do
    File.mkdir_p!(data_dir())
    existing_proofs = load_proofs()
    all_proofs = existing_proofs ++ proofs
    File.write!("#{data_dir()}/#{proof_file()}", Jason.encode!(all_proofs))
  end

  defp show_balance do
    proofs = load_proofs()

    balance =
      proofs
      |> Enum.group_by(& &1.amount)
      |> Enum.map(fn {amount, proofs} -> {amount, length(proofs)} end)
      |> Enum.sort()

    IO.puts("Your balance:")

    total_balance =
      Enum.reduce(balance, 0, fn {amount, count}, acc ->
        IO.puts("  Amount: #{amount}, Count: #{count}")
        acc + (amount || 0) * count
      end)

    IO.puts("\nTotal balance: #{total_balance}")
  end

  defp load_proofs do
    case File.read("#{data_dir()}/#{proof_file()}") do
      {:ok, content} ->
        Jason.decode!(content)
        |> Enum.map(fn proof ->
          proof = for {key, val} <- proof, into: %{}, do: {String.to_atom(key), val}
          struct(Proof, proof)
        end)

      {:error, _} ->
        []
    end
  end

  defp split_amount(amount) do
    amount
    |> Integer.digits(2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.filter(fn {bit, _} -> bit == 1 end)
    |> Enum.map(fn {_, index} -> :math.pow(2, index) |> round() end)
    |> Enum.reverse()
  end
end
