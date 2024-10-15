defmodule Cashubrew.Web.MintController do
  use Cashubrew.Web, :controller
  alias Cashubrew.Mint
  alias Cashubrew.Nuts.Nut00
  alias Cashubrew.Nuts.Nut01
  alias Cashubrew.Nuts.Nut02
  alias Cashubrew.Nuts.Nut03
  alias Cashubrew.Nuts.Nut04
  alias Cashubrew.Nuts.Nut06

  def info(conn, _params) do
    info = Nut06.Info.info()
    json(conn, info)
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def keysets(conn, _params) do
    keysets = Nut02.Impl.keysets()
    json(conn, Nut02.Serde.GetKeysetsResponse.from_keysets(keysets))
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def keys(conn, _params) do
    keysets_with_keys = Nut01.Impl.active_keysets_with_keys()
    json(conn, Nut01.Serde.GetKeysResponse.from_keysets(keysets_with_keys))
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def keys_for_keyset(conn, %{"keyset_id" => keyset_id}) do
    keyset_with_keys = Nut02.Impl.keys_for_keyset_id!(keyset_id)
    json(conn, Nut01.Serde.GetKeysResponse.from_keysets([keyset_with_keys]))
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def swap(conn, params) do
    %Nut03.Serde.PostSwapRequest{inputs: proofs, outputs: blinded_messages} = params["body"]
    signatures = Nut03.Impl.swap!(proofs, blinded_messages)
    json(conn, %Nut03.Serde.PostSwapResponse{signatures: signatures})
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def create_mint_quote(conn, params) do
    %Nut04.Serde.PostMintQuoteBolt11Request{
      amount: amount,
      unit: unit,
      description: _description
    } = params["body"]

    res = Nut04.Impl.create_mint_quote!(amount, unit)
    json(conn, struct(Nut04.Serde.PostMintBolt11Response, %{res | state: "UNPAID"}))
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def get_mint_quote(conn, %{"quote_id" => quote_id}) do
    res = Nut04.Impl.get_mint_quote(quote_id)
    json(conn, struct(Nut04.Serde.PostMintBolt11Response, res))
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  defp validate_blinded_messages(outputs) do
    blinded_messages =
      Enum.map(outputs, fn output ->
        Nut00.BlindedMessage.from_map(output)
      end)

    {:ok, blinded_messages}
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
