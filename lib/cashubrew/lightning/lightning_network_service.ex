defmodule Cashubrew.Lightning.LightningNetworkService do
  @moduledoc """
  Lightning Network Services.
  """
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{invoices: %{}}}
  end

  def create_invoice(amount, description) do
    GenServer.call(__MODULE__, {:create_invoice, amount, description})
  end

  def check_payment(payment_hash) do
    GenServer.call(__MODULE__, {:check_payment, payment_hash})
  end

  def handle_call({:create_invoice, amount, _description}, _from, state) do

    unit_input="sat" # TODO use NUT setting + permit others unit after
    attributes = %{
      out: "false",
      amount: amount,
      unit_input: unit_input,
    }

    case Cashubrew.LNBits.Api.post_data("api/v1/payments",attributes) do
      {:ok, response_body} ->
        IO.puts("Success create in: #{response_body}")

        response_map = Jason.decode!(response_body)
        payment_hash = response_map["payment_hash"]
        payment_request = response_map["payment_request"]
        {:reply, {:ok, payment_request, payment_hash}, response_map}

      {:error, reason} ->
        IO.puts("Error: #{reason}")
    end


  end

  def handle_call({:check_payment, payment_hash}, _from, state) do
    case get_in(state, [:invoices, payment_hash]) do
      nil -> {:reply, {:error, :not_found}, state}
      %{paid: true} -> {:reply, {:ok, :paid}, state}
      %{paid: false} -> {:reply, {:ok, :unpaid}, state}
    end
  end

end
