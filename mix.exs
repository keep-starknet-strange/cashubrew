defmodule Cashubrew.MixProject do
  use Mix.Project

  def project do
    [
      app: :cashubrew,
      version: "0.0.1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        bench: :dev
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {Cashubrew.Application, []}
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:benchee_html, "~> 1.0", only: :dev},
      {:block_keys, "~> 1.0.2"},
      {:cbor, "~> 1.0.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.10"},
      {:ex_bech32, "~> 0.5.0"},
      {:ex_secp256k1, "~> 0.7.0"},
      {:excoveralls, "~> 0.18", only: :test},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.20"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:phoenix, "~> 1.7.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.0"},
      {:plug_cowboy, "~> 2.5"},
      {:postgrex, ">= 0.0.0"},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:bitcoinex, "~> 0.1.7"},
      {:dotenv, "~> 3.0.0"},
      {:meck, "~> 0.9"},
      {:protobuf, "~> 0.13.0"},
      {:grpc, "~> 0.9.0"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        &setup_test_environment/1,
        "test"
      ]
    ]
  end

  defp setup_test_environment(_) do
    if System.get_env("MOCK_DB") != "true" do
      Mix.Task.run("ecto.create", ["--quiet"])
      Mix.Task.run("ecto.migrate", ["--quiet"])
    end
  end
end
