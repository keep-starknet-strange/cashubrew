import Config

config :cashubrew, Cashubrew.Web.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  watchers: []

# Watch static and templates for browser reloading.
config :cashubrew, Cashubrew.Web.Endpoint,
  live_reload: [
    patterns: [
      ~r"lib/cashubrew/web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :cashubrew, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n", lever: :debug

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :cashubrew, Cashubrew.Repo,
  database: "cashubrew_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5432,
  pool_size: 10

config :cashubrew, :repo, Cashubrew.Repo

config :cashubrew, ecto_repos: [Cashubrew.Repo]

config :cashubrew, :lnd_client, Cashubrew.LightingNetwork.Lnd

config :cashubrew, :ssl_verify, :verify_none
