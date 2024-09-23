defmodule Gakimint.Web.MintController do
  use Gakimint.Web, :controller
  alias Gakimint.Mint
  alias Gakimint.Web.{Keys, KeysetResponse}

  def info(conn, _params) do
    info = %{
      name: "Gakimint Cashu Mint",
      pubkey: Base.encode16(Mint.get_pubkey(), case: :lower),
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
      time: System.os_time(:second),
      nuts: %{
        "4": %{
          methods: [
            %{
              method: "bolt11",
              unit: "sat",
              min_amount: 0,
              max_amount: 10_000
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
              max_amount: 10_000
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
    keysets = Mint.get_active_keysets()

    keysets_responses =
      Enum.map(keysets, fn keyset ->
        keys = Mint.get_keys_for_keyset(keyset.id)

        keys_list =
          Enum.map(keys, fn key -> {key.amount, Base.encode16(key.public_key, case: :lower)} end)

        %KeysetResponse{
          id: keyset.id,
          unit: keyset.unit,
          keys: %Keys{pairs: keys_list}
        }
      end)

    response = %{
      keysets: keysets_responses
    }

    json(conn, response)
  end
end
