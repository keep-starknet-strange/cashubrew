defmodule Cashubrew.Application do
  @moduledoc false
  use Application
  alias Cashubrew.Web.Endpoint

  @impl true
  def start(_type, _args) do
    children = [
      Cashubrew.Web.Telemetry,
      Application.get_env(:cashubrew, :lnd_client),
      {Phoenix.PubSub, name: Cashubrew.PubSub},
      Endpoint,
      Application.get_env(:cashubrew, :repo),
      {Task, fn -> Cashubrew.Mint.init() end}
    ]

    opts = [strategy: :one_for_one, name: Cashubrew.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
