defmodule Cashubrew.LightingNetwork.Lnd do
  @moduledoc """
    Client to interact with lnd
  """
  use GenServer
  require Logger

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl GenServer
  def init(args) do
    node_url = URI.parse(System.get_env("LND_URL"))
    creds = get_creds(System.get_env("LND_CERT"))
    macaroon = get_macaroon(System.get_env("LND_MACAROON"))

    Logger.debug("gRPC client connecting to gateway at #{node_url}")

    case GRPC.Stub.connect("#{node_url.host}:#{node_url.port}",
           cred: creds
         ) do
      {:error, error} ->
        Logger.critical("Could not connect. Retrying... #{error}")
        init(args)

      {:ok, channel} ->
        Logger.info("Connected to the gateway at #{node_url}")
        {:ok, %{channel: channel, macaroon: macaroon}}
    end
  end

  # one day
  def validity, do: 86_400

  def create_invoice!(amount, unit, description) do
    GenServer.call(__MODULE__, {:create_invoice, amount, unit, description})
  end

  @impl GenServer
  def handle_call(
        {:create_invoice, amount, unit, description},
        _from,
        %{channel: channel, macaroon: macaroon} = state
      ) do
    if unit != "sat" do
      raise "UnsuportedUnit"
    end

    amount_ms = amount * 1000

    expiry = validity()

    request = %Cashubrew.Lnrpc.Invoice{
      memo: description,
      value_msat: amount_ms,
      expiry: expiry
    }

    {:ok, response} =
      Cashubrew.Lnrpc.Lightning.Stub.add_invoice(channel, request,
        metadata: %{macaroon: macaroon}
      )

    {:reply, {expiry, response}, state}
  end

  defp get_creds(cert_path) do
    filename = Path.expand(cert_path)

    verify = Application.get_env(:cashubrew, :ssl_verify)
    ssl_opts = [cacertfile: filename, verify: verify]

    GRPC.Credential.new(ssl: ssl_opts)
  end

  defp get_macaroon(macaroon_path) do
    filename = Path.expand(macaroon_path)

    File.read!(filename) |> Base.encode16()
  end
end
