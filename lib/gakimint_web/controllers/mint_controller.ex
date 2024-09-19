defmodule GakimintWeb.MintController do
  use GakimintWeb, :controller

  def info(conn, _params) do
    info = %{
      name: "Gakimint Cashu Mint",
      pubkey: "",
      version: "Gakimint/0.1.0",
      description: "An Elixir implementation of Cashu Mint",
      description_long: "A Cashu Mint implementation in Elixir.",
      contact: [
        %{
          method: "twitter",
          value: "@dimahledba"
        },
        %{
          method: "nostr",
          value: "npub1hr6v96g0phtxwys4x0tm3khawuuykz6s28uzwtj5j0zc7lunu99snw2e29"
        }
      ],
      nuts: %{
        "4": %{
          methods: [
            %{
              method: "bolt11",
              unit: "sat",
              min_amount: 0,
              max_amount: 10000
            }
          ],
          disabled: false
        },
        "5": %{
          methods: [
            %{
              method: "bolt11",
              unit: "sat",
              min_amount: 100,
              max_amount: 10000
            }
          ],
          disabled: false
        },
        "7": %{
          supported: false
        },
        "8": %{
          supported: false
        },
        "9": %{
          supported: false
        },
        "10": %{
          supported: false
        },
        "12": %{
          supported: false
        }
      },
      motd: "Welcome to Gakimint!"
    }

    json(conn, info)
  end

  def keys(conn, _params) do
    keysets = Gakimint.Mint.get_keysets()

    response = %{
      keysets:
        Enum.map(keysets, fn keyset ->
          keys = Gakimint.Mint.get_keys_for_keyset(keyset.id)
          keys_map = Enum.into(keys, %{}, fn key -> {key.amount, key.public_key} end)

          # Log the number of keys in the response
          IO.inspect(Map.keys(keys_map) |> length(), label: "Number of keys in API response")

          %{
            id: keyset.id,
            unit: keyset.unit,
            keys: keys_map
          }
        end)
    }

    json(conn, response)
  end
end
