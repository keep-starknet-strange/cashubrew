import Config

config :cashubrew, Cashubrew.Web.Endpoint,
  url: [
    host: System.get_env("APP_HOST", "localhost"),
    port: String.to_integer(System.get_env("PORT", "4000"))
  ],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :cashubrew, Cashubrew.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :cashubrew, :repo, Cashubrew.Repo

config :logger, level: :info

config :cashubrew, Cashubrew.Web.Endpoint, secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

# Use mock ln if MOCK_LN environment variable is set to "true"
if System.get_env("MOCK_LN") == "true" do
  config :cashubrew, :ln, Cashubrew.Lightning.MockLightningNetworkService
else
  config :cashubrew, :ln, Cashubrew.Lightning.LightningNetworkService
end
