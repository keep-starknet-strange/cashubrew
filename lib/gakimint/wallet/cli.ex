defmodule Gakimint.Wallet.CLI do
  @moduledoc """
  A simple CLI wallet for interacting with the Gakimint mint.
  """

  alias Gakimint.Crypto.BDHKE
  alias Gakimint.Cashu.{BlindedMessage, Proof}
  require Logger

  @mint_url "http://localhost:4000/api/v1"
  @data_dir "./_build/.gakimint/data"
  @proof_file "proofs.json"
  @wallet_file "wallet.json"

  def main(args) do
    case args do
      ["mint", amount_str] ->
        amount = String.to_integer(amount_str)
        mint_tokens(amount)

      ["balance"] ->
        show_balance()

      _ ->
        IO.puts("Usage:")
        IO.puts(~S|  mix run -e 'Gakimint.Wallet.CLI.main(["mint", "<amount>"])'|)
        IO.puts(~S|  mix run -e 'Gakimint.Wallet.CLI.main(["balance"])'|)
    end
  end

  defp mint_tokens(amount) do
    IO.puts("Minting tokens...")
    wallet = load_or_create_wallet()
    IO.puts("Wallet: #{inspect(wallet)}")

    # Step 1: Request a mint quote
    case request_mint_quote(amount) do
      {:ok, quote} ->
        # Step 2: Generate secrets and blinded messages
        case generate_blinded_messages(amount) do
          {:ok, {blinded_messages, secrets, rs}} ->
            # Step 3: Mint tokens
            case send_mint_request(quote["quote"], blinded_messages) do
              {:ok, signatures} ->
                # Step 4: Unblind signatures to obtain proofs
                proofs = unblind_signatures(wallet, signatures, secrets, rs)

                # Step 5: Store proofs
                store_proofs(proofs)
                IO.puts("Minted tokens successfully!")
                show_balance()

              {:error, reason} ->
                IO.puts("Error minting tokens: #{reason}")
            end

          {:error, reason} ->
            IO.puts("Error generating blinded messages: #{reason}")
        end

      {:error, reason} ->
        IO.puts("Error requesting mint quote: #{reason}")
    end
  end

  defp request_mint_quote(amount) do
    url = "#{@mint_url}/mint/quote/bolt11"
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
    case get_active_keyset_id() do
      {:ok, keyset_id} ->
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

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_active_keyset_id do
    url = "#{@mint_url}/keysets"
    headers = [{"Content-Type", "application/json"}]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        response = Jason.decode!(response_body)
        keysets = response["keysets"]

        case Enum.find(keysets, fn ks -> ks["active"] == true end) do
          %{"id" => keyset_id} ->
            {:ok, keyset_id}

          nil ->
            {:error, "No active keyset found"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        {:error, "HTTP Error #{status_code}: #{response_body}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP Error: #{inspect(reason)}"}
    end
  end

  defp send_mint_request(quote_id, blinded_messages) do
    url = "#{@mint_url}/mint/bolt11"
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
    case wallet do
      %{public_key: nil} ->
        IO.puts("Error: Wallet public key is nil. Generating a new wallet.")
        new_wallet = generate_wallet()
        unblind_signatures(new_wallet, signatures, secrets, rs)

      %{public_key: public_key} ->
        a_pub = Base.decode16!(public_key, case: :lower)

        proofs =
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

        proofs
    end
  end

  defmodule Wallet do
    @moduledoc """
    Struct representing a wallet with private and public keys.
    """
    @derive Jason.Encoder
    defstruct [:private_key, :public_key]
  end

  defp load_or_create_wallet do
    case load_wallet() do
      nil ->
        generate_wallet()

      wallet ->
        case struct(Wallet, wallet) do
          %Wallet{private_key: nil} -> generate_wallet()
          %Wallet{public_key: nil} -> generate_wallet()
          valid_wallet -> valid_wallet
        end
    end
  end

  defp generate_wallet do
    {private_key, public_key} = BDHKE.generate_keypair()

    wallet = %Wallet{
      private_key: Base.encode16(private_key, case: :lower),
      public_key: Base.encode16(public_key, case: :lower)
    }

    store_wallet(wallet)
    wallet
  end

  defp load_wallet do
    case File.read("#{@data_dir}/#{@wallet_file}") do
      {:ok, content} ->
        Jason.decode!(content)

      {:error, _} ->
        nil
    end
  end

  defp store_wallet(wallet) do
    # Ensure the data directory exists
    File.mkdir_p!(@data_dir)
    File.write!("#{@data_dir}/#{@wallet_file}", Jason.encode!(wallet))
  end

  defp store_proofs(proofs) do
    # Ensure the data directory exists
    File.mkdir_p!(@data_dir)
    existing_proofs = load_proofs()
    all_proofs = existing_proofs ++ proofs
    File.write!("#{@data_dir}/#{@proof_file}", Jason.encode!(all_proofs))
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
        acc + amount * count
      end)

    IO.puts("\nTotal balance: #{total_balance}")
  end

  defp load_proofs do
    case File.read("#{@data_dir}/#{@proof_file}") do
      {:ok, content} ->
        Jason.decode!(content)
        |> Enum.map(fn proof ->
          struct(Proof, Map.new(proof, fn {k, v} -> {String.to_atom(k), v} end))
        end)

      {:error, _} ->
        []
    end
  end

  defp split_amount(amount) do
    # Split the amount into powers of two
    # e.g., 13 -> [8, 4, 1]
    powers =
      amount
      |> Integer.digits(2)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.filter(fn {bit, _} -> bit == 1 end)
      |> Enum.map(fn {_, index} -> :math.pow(2, index) |> round() end)

    Enum.reverse(powers)
  end
end
