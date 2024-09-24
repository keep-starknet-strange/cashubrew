defmodule Gakimint.Web.MintController do
  use Gakimint.Web, :controller
  alias Gakimint.Mint
  alias Gakimint.Web.{Keys, KeysetResponse}
  alias Gakimint.Cashu.{BlindedMessage, BlindSignature, Proof}

  def info(conn, _params) do
    info = %{
      name: "Gakimint Cashu Mint",
      pubkey: Base.encode16(Mint.get_pubkey(), case: :lower),
      version: "Gakimint/0.1.0",
      description: "An Elixir implementation of Cashu Mint",
      description_long: "A Cashu Mint implementation in Elixir.",
      contact: [
        %{
          method: "twitter",
          value: "@dimahledba"
        },
        %{
          method: "nostr",
          value: "npub1hr6v96g0phtxwys4x0tm3khawuuykz6s28uzwtj5j0zc7lunu99snw2e29"
        }
      ],
      time: System.os_time(:second),
      nuts: %{
        "4": %{
          methods: [
            %{
              method: "bolt11",
              unit: "sat",
              min_amount: 0,
              max_amount: 10_000
            }
          ],
          disabled: false
        },
        "5": %{
          methods: [
            %{
              method: "bolt11",
              unit: "sat",
              min_amount: 100,
              max_amount: 10_000
            }
          ],
          disabled: false
        },
        "7": %{
          supported: false
        },
        "8": %{
          supported: false
        },
        "9": %{
          supported: false
        },
        "10": %{
          supported: false
        },
        "12": %{
          supported: false
        }
      },
      motd: "Welcome to Gakimint!"
    }

    json(conn, info)
  end

  def keysets(conn, _params) do
    repo = Application.get_env(:gakimint, :repo)
    keysets = Mint.get_all_keysets(repo)

    keysets_responses =
      Enum.map(keysets, fn keyset ->
        %{
          id: keyset.id,
          unit: keyset.unit,
          active: keyset.active,
          input_fee_ppk: keyset.input_fee_ppk || 0
        }
      end)

    response = %{
      keysets: keysets_responses
    }

    json(conn, response)
  end

  def keys(conn, _params) do
    repo = Application.get_env(:gakimint, :repo)
    keysets = Mint.get_active_keysets(repo)

    keysets_responses =
      Enum.map(keysets, fn keyset ->
        keys = Mint.get_keys_for_keyset(repo, keyset.id)

        keys_list =
          Enum.map(keys, fn key -> {key.amount, Base.encode16(key.public_key, case: :lower)} end)

        %KeysetResponse{
          id: keyset.id,
          unit: keyset.unit,
          keys: %Keys{pairs: keys_list}
        }
      end)

    response = %{
      keysets: keysets_responses
    }

    json(conn, response)
  end

  def keys_for_keyset(conn, %{"keyset_id" => keyset_id}) do
    repo = Application.get_env(:gakimint, :repo)
    keyset = Mint.get_keyset(repo, keyset_id)

    if keyset do
      keys = Mint.get_keys_for_keyset(repo, keyset_id)

      keys_list =
        Enum.map(keys, fn key ->
          {key.amount, Base.encode16(key.public_key, case: :lower)}
        end)

      keyset_response = %KeysetResponse{
        id: keyset.id,
        unit: keyset.unit,
        keys: %Keys{pairs: keys_list}
      }

      response = %{
        keysets: [keyset_response]
      }

      json(conn, response)
    else
      conn
      |> put_status(:not_found)
      |> json(%{error: "Keyset not found"})
    end
  end

  def swap(conn, %{"inputs" => inputs, "outputs" => outputs}) do
    repo = Application.get_env(:gakimint, :repo)

    with {:ok, proofs} <- validate_proofs(inputs),
         {:ok, blinded_messages} <- validate_blinded_messages(outputs),
         :ok <- validate_amounts(proofs, blinded_messages),
         {:ok, signatures} <- perform_swap(repo, proofs, blinded_messages) do
      json(conn, %{signatures: signatures})
    else
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  defp validate_proofs(inputs) do
    proofs = Enum.map(inputs, &struct(Proof, &1))
    {:ok, proofs}
  end

  defp validate_blinded_messages(outputs) do
    blinded_messages = Enum.map(outputs, &struct(BlindedMessage, &1))
    {:ok, blinded_messages}
  end

  defp validate_amounts(proofs, blinded_messages) do
    input_sum = Enum.reduce(proofs, 0, &(&1.amount + &2))
    output_sum = Enum.reduce(blinded_messages, 0, &(&1.amount + &2))

    if input_sum == output_sum do
      :ok
    else
      {:error, "Input and output amounts do not match"}
    end
  end

  defp perform_swap(repo, proofs, blinded_messages) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:verify_proofs, fn _, _ ->
      verify_proofs(repo, proofs)
    end)
    |> Ecto.Multi.run(:invalidate_proofs, fn _, _ ->
      invalidate_proofs(repo, proofs)
    end)
    |> Ecto.Multi.run(:sign_outputs, fn _, _ ->
      sign_outputs(repo, blinded_messages)
    end)
    |> repo.transaction()
    |> case do
      {:ok, %{sign_outputs: signatures}} -> {:ok, signatures}
      {:error, _, reason, _} -> {:error, reason}
    end
  end

  defp verify_proofs(_repo, proofs) do
    # Implement proof verification logic
    # This should check if the proofs are valid and not already spent
    {:ok, proofs}
  end

  defp invalidate_proofs(_repo, _proofs) do
    # Implement proof invalidation logic
    # This should mark the proofs as spent in the database
    :ok
  end

  defp sign_outputs(_repo, blinded_messages) do
    # Implement output signing logic
    # This should create new BlindSignatures for the blinded messages
    signatures =
      Enum.map(blinded_messages, fn bm ->
        %BlindSignature{
          amount: bm.amount,
          id: bm.id,
          # Replace with actual signature logic
          C_: "dummy_signature"
        }
      end)

    {:ok, signatures}
  end
end
