defmodule GakimintWeb.MintController do
  use GakimintWeb, :controller

  alias Gakimint.Mint

  def info(conn, _params) do
    info = %{
      name: "Gakimint Cashu Mint",
      pubkey: Mint.get_keyset().public_keys[1],
      version: "Gakimint/0.1.0",
      description: "An Elixir implementation of Cashu Mint",
      description_long: "A Cashu Mint implementation in Elixir.",
      contact: [
        %{
          method: "github",
          value: "https://github.com/AbdelStark/gakimint"
        }
      ],
      motd: "Welcome to Gakimint!"
    }

    json(conn, info)
  end

  def keys(conn, _params) do
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

    json(conn, response)
  end
end
