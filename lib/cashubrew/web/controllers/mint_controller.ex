defmodule Cashubrew.Web.MintController do
  use Cashubrew.Web, :controller
  require :logger
  require Logger
  alias Cashubrew.Mint
  alias Cashubrew.Nuts.Nut00
  alias Cashubrew.Nuts.Nut01
  alias Cashubrew.Nuts.Nut02
  alias Cashubrew.Nuts.Nut03
  alias Cashubrew.Nuts.Nut04
  alias Cashubrew.Nuts.Nut05
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
    %{inputs: proofs, outputs: blinded_messages} =
      Nut03.Serde.PostSwapRequest.from_map(params["body"])

    signatures = Nut03.Impl.swap!(proofs, blinded_messages)
    json(conn, %Nut03.Serde.PostSwapResponse{signatures: signatures})
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def create_mint_quote(
        conn,
        %{
          "method" => method,
          "amount" => amount,
          "unit" => unit
        } = params
      ) do
    if method != "bolt11" do
      raise "UnsuportedMethod"
    end

    description = Map.get(params, "description")

    res = Nut04.Impl.create_mint_quote!(amount, unit, description)

    json(
      conn,
      struct(
        Nut04.Serde.PostMintQuoteBolt11Response,
        res
      )
    )
  rescue
    e in RuntimeError ->
      conn
      |> put_status(:bad_request)
      |> json(%{error: e.message})
  end

  def get_mint_quote(conn, %{"quote_id" => quote_id, "method" => method}) do
    if method != "bolt11" do
      raise "UnsuportedMethod"
    end

    res = Nut04.Impl.get_mint_quote(quote_id)
    json(conn, struct(Nut04.Serde.PostMintBolt11Response, res))
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def mint_tokens(conn, params) do
    method = params["method"]

    if method != "bolt11" do
      raise "UnsuportedMethod"
    end

    %{quote: quote_id, outputs: blinded_messages} =
      Nut04.Serde.PostMintBolt11Request.from_map(params["body"])

    signatures = Nut04.Impl.mint_tokens!(quote_id, blinded_messages)
    json(conn, %Nut04.Serde.PostMintBolt11Response{signatures: signatures})
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def create_melt_quote(conn, %{"method" => method, "request" => request, "unit" => unit}) do
    if method != "bolt11" do
      raise "UnsuportedMethod"
    end

    res = Nut05.Impl.create_melt_quote!(request, unit)

    json(conn, struct(Nut05.Serde.PostMeltQuoteBolt11Response, res))
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
  end

  def get_melt_quote(conn, %{"method" => method, "quote_id" => quote_id}) do
    if method != "bolt11" do
      raise "UnsuportedMethod"
    end

    melt_quote = Nut05.Impl.get_melt_quote_by_id(quote_id)
    # TODO: get actual state from ln and payment_preimage
    json(conn, Nut05.Serde.PostMeltQuoteBolt11Response.from_melt_quote(melt_quote, "UNPAID", nil))
  rescue
    e in RuntimeError -> conn |> put_status(:bad_request) |> json(Nut00.Error.new_error(0, e))
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
