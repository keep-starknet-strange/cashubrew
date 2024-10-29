defmodule Cashubrew.Nuts.Nut06.Info do
  @moduledoc """
  Implementation and structs of the NUT-06
  """
  alias Cashubrew.Nuts.Nut04
  alias Cashubrew.Nuts.Nut05

  @derive [Jason.Encoder]
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
    @moduledoc """
    A Contact info
    """
    @enforce_keys [:method, :info]
    @derive [Jason.Encoder]
    defstruct [:method, :info]
  end

  def info do
    info = %__MODULE__{
      name: "Cashubrew Cashu Mint",
      pubkey: "0381094f72790bb014504dfc9213bd3c8450440f5d220560075dbf2f8113e9fa3e",
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
        "4": %{methods: [Nut04.MintMethodSetting.bolt11()], disabled: false},
        "5": %{methods: [Nut05.MeltMethodSetting.bolt11()], disabled: false},
        "7": %{supported: false},
        "8": %{supported: false},
        "9": %{supported: false},
        "10": %{supported: false},
        "11": %{supported: false},
        "12": %{supported: false},
        "14": %{supported: false},
        "15": %{methods: []}
      },
      motd: nil
    }

    info
  end
end
