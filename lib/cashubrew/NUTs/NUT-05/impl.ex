defmodule Cashubrew.Nuts.Nut05.Impl do
  @moduledoc """
  Implementation and structs of the NUT-05
  """
  alias Cashubrew.Schema

  defp percent_fee_reserve, do: 1
  defp min_fee_reserve, do: 1
  # 15min
  defp melt_quote_validity_duration_in_sec, do: 900

  def create_melt_quote!(request, unit) do
    {:ok, ln_invoice} = Bitcoinex.LightningNetwork.decode_invoice(request)

    repo = Application.get_env(:cashubrew, :repo)

    amount =
      case unit do
        "sat" -> div(ln_invoice.amount_msat, 1000)
        _ -> raise "UnsupportedUnit"
      end

    # TODO: impl max_amout min_amount config checks

    relative_fee_reserve = amount * percent_fee_reserve() / 100
    fee = max(relative_fee_reserve, min_fee_reserve())

    expiry = System.os_time(:second) + melt_quote_validity_duration_in_sec()
    quote_id = Ecto.UUID.bingenerate()

    Schema.MeltQuote.create!(repo, %{
      id: quote_id,
      request: request,
      unit: unit,
      amount: amount,
      fee_reserve: fee,
      expiry: expiry,
      request_lookup_id: ln_invoice.payment_hash
    })

    %{quote_id: quote_id, amount: amount, fee_reserve: fee, expiry: expiry}
  end
end
