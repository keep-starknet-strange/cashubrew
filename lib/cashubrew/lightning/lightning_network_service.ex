defmodule Cashubrew.Lightning.LightningNetworkService do
  @moduledoc """
  Lightning Network Services.
  """
  alias Cashubrew.LNBitsApi

  def create_invoice!(amount, unit) do
    body = %{
      out: "false",
      amount: amount,
      unit_input: unit
    }

    case LNBitsApi.make_post("api/v1/payments", body) do
      {:ok, response_body} ->
        response_map = Jason.decode!(response_body)
        payment_hash = response_map["payment_hash"]
        payment_request = response_map["payment_request"]
        {payment_request, payment_hash}

      {:error, reason} ->
        raise reason
    end
  end

  def invoice_paid?(payment_hash) do
    case LNBitsApi.make_get("api/v1/payments/#{payment_hash}") do
      {:ok, response_body} ->
        response_map = Jason.decode!(response_body)
        paid = response_map["paid"]
        paid

      {:error, reason} ->
        raise reason
    end
  end
end
