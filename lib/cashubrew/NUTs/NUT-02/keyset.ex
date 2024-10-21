defmodule Cashubrew.Nuts.Nut02.Keyset do
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
