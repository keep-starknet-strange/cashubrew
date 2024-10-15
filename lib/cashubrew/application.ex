defmodule Cashubrew.Application do
  @moduledoc false
  use Application
  alias Cashubrew.Web.Endpoint

  @impl true
  def start(_type, _args) do
    children = [
      Cashubrew.Web.Telemetry,
      {Phoenix.PubSub, name: Cashubrew.PubSub},
      Endpoint
    ]

    # Conditionally add the appropriate repo to the children list
    children =
      case Application.get_env(:cashubrew, :repo) do
        Cashubrew.MockRepo -> [Cashubrew.MockRepo | children]
        Cashubrew.Repo -> [Cashubrew.Repo | children]
        _ -> children
      end

    # Always add Cashubrew.Mint after the repo
    children = children ++ [Cashubrew.Mint]

    opts = [strategy: :one_for_one, name: Cashubrew.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
