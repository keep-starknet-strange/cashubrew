defmodule Cashubrew.Nuts.Nut06.Info do
  use Cashubrew.Web, :controller

  defstruct [
    :name,
    :pubkey,
    :version,
    :description,
    :description_long,
    :contact,
    :motd,
    :icon_url,
    :time,
    :nuts
  ]

  defmodule Contact do
    @enforce_keys [:method, :info]
    defstruct [:method, :info]
  end

  def info(conn) do
    info = %__MODULE__{
      name: "Cashubrew Cashu Mint",
      pubkey: Base.encode16(Mint.get_pubkey(), case: :lower),
      version: "Cashubrew/0.1.0",
      description: "An Elixir implementation of Cashu Mint",
      description_long: nil,
      contact: [
        %Contact{
          method: "twitter",
          info: "@dimahledba"
        },
        %Contact{
          method: "nostr",
          info: "npub1hr6v96g0phtxwys4x0tm3khawuuykz6s28uzwtj5j0zc7lunu99snw2e29"
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
      motd: nil
    }

    json(conn, info)
  end
end
