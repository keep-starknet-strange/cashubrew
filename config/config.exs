import Config

config :gakimint,
  ecto_repos: [Gakimint.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :gakimint, Gakimint.Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: Gakimint.Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: Gakimint.PubSub,
  live_view: [signing_salt: "gakimint_live_view_signing_salt"]

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
