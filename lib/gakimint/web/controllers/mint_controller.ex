defmodule Gakimint.Web.MintController do
  use Gakimint.Web, :controller
  alias Gakimint.Cashu.BlindedMessage
  alias Gakimint.Mint
  alias Gakimint.Web.{Keys, KeysetResponse}

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

  def swap(_conn, _params) do
    {:error, "Not implemented yet"}
  end

  defp validate_blinded_messages(outputs) do
    blinded_messages =
      Enum.map(outputs, fn output ->
        convert_to_blinded_message(output)
      end)

    {:ok, blinded_messages}
  end

  defp convert_to_blinded_message(output) do
    %BlindedMessage{
      amount: Map.fetch!(output, "amount"),
      id: Map.fetch!(output, "id"),
      B_: Map.fetch!(output, "B_")
    }
  end

  def create_mint_quote(conn, %{"amount" => amount, "unit" => "sat"} = params) do
    description = Map.get(params, "description")

    case Mint.create_mint_quote(amount, description) do
      {:ok, quote} ->
        conn
        |> put_status(:created)
        |> json(%{
          quote: quote.id,
          request: quote.payment_request,
          state: "UNPAID",
          expiry: quote.expiry
        })

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def get_mint_quote(conn, %{"quote_id" => quote_id}) do
    case Mint.get_mint_quote(quote_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Quote not found"})

      quote ->
        json(conn, %{
          quote: quote.id,
          request: quote.payment_request,
          state: quote.state,
          expiry: quote.expiry
        })
    end
  end

  def mint_tokens(conn, %{"quote" => quote_id, "outputs" => outputs}) do
    case validate_blinded_messages(outputs) do
      {:ok, blinded_messages} ->
        case Mint.mint_tokens(quote_id, blinded_messages) do
          {:ok, signatures} ->
            json(conn, %{signatures: signatures})

          {:error, reason} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: reason})
        end
    end
  end

  def melt_quote(conn, %{"request" => request, "unit" => unit}) do
    case Mint.create_melt_quote(request, unit) do
      {:ok, quote} ->
        conn
        |> put_status(:created)
        |> json(%{
          request: quote.request,
          quote: quote.id,
          amount: quote.amount,
          fee_reserve: quote.fee_reserve,
          state: "UNPAID",
          expiry: quote.expiry
        })

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def melt_tokens(conn, %{"quote_id" => quote_id, "inputs" => inputs}) do
    case Mint.create_melt_tokens(quote_id, inputs) do
      {:ok, quote} ->
        conn
        |> put_status(:created)
        |> json(%{
          quote: quote.id,
          request: quote.payment_request,
          state: "UNPAID",
          expiry: quote.expiry
        })

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

end
