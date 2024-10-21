defmodule Cashubrew.Nuts.Nut02.GetKeysetsResponse do
  @moduledoc """
  The body of the get keysets rest response
  """
  @enforce_keys [:keysets]
  @derive [Jason.Encoder]
  defstruct [:keysets]

  def from_keysets(keysets) do
    keysets_responses =
      Enum.map(keysets, &Cashubrew.Nuts.Nut02.Keyset.from_keyset(&1))

    %__MODULE__{
      keysets: keysets_responses
    }
  end
end
