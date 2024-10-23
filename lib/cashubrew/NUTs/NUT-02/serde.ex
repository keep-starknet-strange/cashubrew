defmodule Cashubrew.Nuts.Nut02.Serde.Keyset do
  @moduledoc """
  A keyset
  """
  @enforce_keys [:id, :unit, :active]
  @derive [Jason.Encoder]
  defstruct [:id, :unit, :active, :input_fee_ppk]

  def from_keyset(keyset) do
    %__MODULE__{
      id: keyset.id,
      unit: keyset.unit,
      active: keyset.active,
      input_fee_ppk: keyset.input_fee_ppk
    }
  end
end

defmodule Cashubrew.Nuts.Nut02.Serde.GetKeysetsResponse do
  @moduledoc """
  The body of the get keysets rest response
  """
  @enforce_keys [:keysets]
  @derive [Jason.Encoder]
  defstruct [:keysets]

  def from_keysets(keysets) do
    keysets_responses = Enum.map(keysets, &Cashubrew.Nuts.Nut02.Serde.Keyset.from_keyset(&1))

    %__MODULE__{
      keysets: keysets_responses
    }
  end
end
