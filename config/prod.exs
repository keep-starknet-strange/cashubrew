import Config

config :gakimint, Gakimint.Web.Endpoint,
  url: [
    host: System.get_env("APP_HOST", "localhost"),
    port: String.to_integer(System.get_env("PORT", "4000"))
  ],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :gakimint, Gakimint.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :logger, level: :info

config :gakimint, Gakimint.Web.Endpoint, secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info
