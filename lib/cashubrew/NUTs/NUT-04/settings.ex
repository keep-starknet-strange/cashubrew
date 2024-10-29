defmodule Cashubrew.Nuts.Nut04.MintMethodSetting do
  @moduledoc """
  The infos retlated to this Nut support
  """

  @enforce_keys [:method, :unit]
  @derive [Jason.Encoder]
  defstruct [:method, :unit, :min_amount, :max_amount, :description]

  @doc """
  Return the map to be used in Nut06 info "nuts" field
  """
  def bolt11 do
    %__MODULE__{
      method: "bolt11",
      unit: "sat"
    }
  end
end
