defmodule Gakimint.Router do
  use Plug.Router
  alias Gakimint.Mint

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/v1/info" do
    info = %{
      name: "Gakimint Cashu Mint",
      pubkey: Mint.get_keyset().public_keys[1],
      version: "Gakimint/0.1.0",
      description: "An Elixir implementation of Cashu Mint",
      description_long: "A Cashu Mint implementation in Elixir",
      contact: [
        %{
          method: "github",
          value: "https://github.com/AbdelStark/gakimint"
        }
      ],
      motd: "Welcome to Gakimint!",
      nuts: %{
        "4": %{methods: [%{method: "bolt11", unit: "sat"}], disabled: false},
        "5": %{methods: [%{method: "bolt11", unit: "sat"}], disabled: false}
      }
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(info))
  end

  get "/v1/keys" do
    keyset = Mint.get_keyset()

    response = %{
      keysets: [
        %{
          id: keyset.id,
          unit: "sat",
          keys: keyset.public_keys
        }
      ]
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(response))
  end

  # Implement other endpoints (mint, melt, swap) here

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
