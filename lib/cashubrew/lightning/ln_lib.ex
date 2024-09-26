defmodule Cashubrew.LightningLib do
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

  def decode_invoice(payment_hash) do
    GenServer.call(__MODULE__, {:decode_invoice, payment_hash})
  end

  def handle_call({:decode_invoice, invoice}, _from, state) do
  end


end
