import Config

config :cashubrew,
  ecto_repos: [Cashubrew.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :cashubrew, Cashubrew.Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: Cashubrew.Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: Cashubrew.PubSub,
  live_view: [signing_salt: "cashubrew_live_view_signing_salt"]

# Configures Elixir's Logger
config :logger, :console,
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
