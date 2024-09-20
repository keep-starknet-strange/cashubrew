defmodule Gakimint.Application do
  @moduledoc false
  use Application
  alias Gakimint.Web.Endpoint

  @impl true
  def start(_type, _args) do
    children = [
      Gakimint.Web.Telemetry,
      Gakimint.Repo,
      {Phoenix.PubSub, name: Gakimint.PubSub},
      Endpoint,
      Gakimint.Mint
    ]

    opts = [strategy: :one_for_one, name: Gakimint.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
