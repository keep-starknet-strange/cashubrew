defmodule Cashubrew.Web.MintController do
  use Cashubrew.Web, :controller
  alias Cashubrew.Mint
  alias Cashubrew.Nuts.Nut00
  alias Cashubrew.Nuts.Nut01
  alias Cashubrew.Nuts.Nut02
  alias Cashubrew.Nuts.Nut06

  def info(conn, _params) do
    info = Nut06.Info.info()
    json(conn, info)
  end

  def keysets(conn, _params) do
    repo = Application.get_env(:cashubrew, :repo)
    keysets = Mint.get_all_keysets(repo)

    response = Nut02.Serde.GetKeysetsResponse.from_keysets(keysets)

    json(conn, response)
  end

  def keys(conn, _params) do
    repo = Application.get_env(:cashubrew, :repo)
    keysets = Mint.get_active_keysets(repo)

    keysets_with_keys =
      Enum.map(keysets, fn keyset ->
        keys = Mint.get_keys_for_keyset(repo, keyset.id)

        %{id: keyset.id, unit: keyset.unit, keys: keys}
      end)

    response = Nut01.Serde.GetKeysResponse.from_keysets(keysets_with_keys)

    json(conn, response)
  end

  def keys_for_keyset(conn, %{"keyset_id" => keyset_id}) do
    repo = Application.get_env(:cashubrew, :repo)
    keyset = Mint.get_keyset(repo, keyset_id)

    if keyset do
      keys = Mint.get_keys_for_keyset(repo, keyset_id)

      response =
        Nut01.Serde.GetKeysResponse.from_keysets([%{id: keyset.id, unit: keyset.unit, keys: keys}])

      json(conn, response)
    else
      # TODO: use proper error
      # https://cashubtc.github.io/nuts/00/#errors
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
        Nut00.BlindedMessage.from_map(output)
      end)

    {:ok, blinded_messages}
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

      # TODO: use proper error
      # https://cashubtc.github.io/nuts/00/#errors
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

          # TODO: use proper error
          # https://cashubtc.github.io/nuts/00/#errors
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
          quote: quote.request,
          request: quote.request,
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
