defmodule Gakimint.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GakimintWeb.Telemetry,
      Gakimint.Repo,
      {Phoenix.PubSub, name: Gakimint.PubSub},
      GakimintWeb.Endpoint,
      Gakimint.Mint
    ]

    opts = [strategy: :one_for_one, name: Gakimint.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    GakimintWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
