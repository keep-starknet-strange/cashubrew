import Config

lnd_client =
  case config_env() do
    :dev -> Cashubrew.LightingNetwork.Lnd
    :prod -> Cashubrew.LightingNetwork.Lnd
    _ -> Cashubrew.LightingNetwork.MockLnd
  end

ssl_verify =
  case config_env() do
    :prod -> true
    _ -> :verify_none
  end

config :cashubrew, :lnd_client, lnd_client
config :cashubrew, :ssl_verify, ssl_verify

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :cashubrew, Cashubrew.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :cashubrew, :repo, Cashubrew.Repo

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :cashubrew, Cashubrew.Web.Endpoint,
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base
end
