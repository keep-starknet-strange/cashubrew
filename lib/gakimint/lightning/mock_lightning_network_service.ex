defmodule Gakimint.Lightning.MockLightningNetworkService do
  @moduledoc """
  Mock Lightning Network Service for testing purposes.
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
    payment_hash = :crypto.strong_rand_bytes(32) |> Base.encode16(case: :lower)
    payment_request = "lnbc#{amount}n1#{payment_hash}"

    new_state = put_in(state, [:invoices, payment_hash], %{amount: amount, paid: false})

    {:reply, {:ok, payment_request, payment_hash}, new_state}
  end

  def handle_call({:check_payment, payment_hash}, _from, state) do
    case get_in(state, [:invoices, payment_hash]) do
      nil -> {:reply, {:error, :not_found}, state}
      %{paid: true} -> {:reply, {:ok, :paid}, state}
      %{paid: false} -> {:reply, {:ok, :unpaid}, state}
    end
  end

  def handle_call({:simulate_payment, payment_hash}, _from, state) do
    case get_in(state, [:invoices, payment_hash]) do
      nil ->
        {:reply, {:error, :not_found}, state}

      _ ->
        new_state = put_in(state, [:invoices, payment_hash, :paid], true)
        {:reply, :ok, new_state}
    end
  end

  # For testing purposes, we'll add a function to simulate payment
  def simulate_payment(payment_hash) do
    GenServer.call(__MODULE__, {:simulate_payment, payment_hash})
  end
end
