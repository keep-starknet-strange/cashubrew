defmodule Cashubrew.LightingNetwork.Lnd do
  @moduledoc """
    Client to interact with lnd
  """
  use GenServer
  require Logger

  def get_address, do: "https://localhost"

  def start_link(arg) do
    # Todo: validate args are valid url to ln server
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_) do
    Logger.debug("gRPC client connecting to gateway at #{get_address()}")

    case GRPC.Stub.connect(get_address(),
           interceptors: [GRPC.Logger.Client]
         ) do
      {:error, error} ->
        Logger.critical("Could not connect. Retrying... #{error}")
        Process.sleep(5000)
        init(%{})

      {:ok, channel} ->
        Logger.debug("Connected to the gateway at #{get_address()}")
        {:ok, channel}
    end
  end

  # one day
  def validity, do: 86_400

  def create_invoice!(amount, unit, description) do
    GenServer.call(__MODULE__, {:create_invoice, amount, unit, description})
  end

  def handle_call({:create_invoice, amount, unit, description}, _from, channel) do
    if unit != "sat" do
      raise "UnsuportedUnit"
    end

    amount_ms = amount * 1000

    expiry = validity() + System.os_time(:second)

    request = %Cashubrew.Lnrpc.Invoice{
      memo: description,
      value_msat: amount_ms,
      expiry: expiry
    }

    {:ok, response} = Cashubrew.Lnrpc.Lightning.Stub.add_invoice(channel, request)
    {:reply, response, channel}
  end
end
