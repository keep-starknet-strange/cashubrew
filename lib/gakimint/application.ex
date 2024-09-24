defmodule Gakimint.Application do
  @moduledoc false
  use Application
  alias Gakimint.Web.Endpoint

  @impl true
  def start(_type, _args) do
    children = [
      Gakimint.Web.Telemetry,
      {Phoenix.PubSub, name: Gakimint.PubSub},
      Endpoint
    ]

    # Conditionally add the appropriate repo to the children list
    children =
      case Application.get_env(:gakimint, :repo) do
        Gakimint.MockRepo -> [Gakimint.MockRepo | children]
        Gakimint.Repo -> [Gakimint.Repo | children]
        _ -> children
      end

    # Always add Gakimint.Mint after the repo
    children = children ++ [Gakimint.Mint]

    opts = [strategy: :one_for_one, name: Gakimint.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
