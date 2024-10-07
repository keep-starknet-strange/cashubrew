import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cashubrew, Cashubrew.Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "your_secret_key_base_for_tests",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Use mock repo if MOCK_DB environment variable is set to "true"
if System.get_env("MOCK_DB") == "true" do
  config :cashubrew, :repo, Cashubrew.MockRepo
else
  config :cashubrew, Cashubrew.Repo,
    username: "postgres",
    password: "postgres",
    hostname: "localhost",
    database: "cashubrew_test#{System.get_env("MIX_TEST_PARTITION")}",
    pool: Ecto.Adapters.SQL.Sandbox,
    pool_size: 10

  config :cashubrew, :repo, Cashubrew.Repo
end

# Use mock LN if MOCK_LN environment variable is set to "true"
if System.get_env("MOCK_LN") == "true" do
  config :cashubrew, :ln, Cashubrew.Lightning.MockLightningNetworkService
else
  config :cashubrew, :ln, Cashubrew.Lightning.LightningNetworkService
end
