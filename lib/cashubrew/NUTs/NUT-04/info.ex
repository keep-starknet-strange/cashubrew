defmodule Cashubrew.Nuts.Nut04.Info do
  @moduledoc """
  The infos retlated to this Nut support
  """

  @enforce_keys [:method, :unit]
  @derive [Jason.Encoder]
  defstruct [:method, :unit, :min_amount, :max_amount, :description]

  @doc """
  Return the map to be used in Nut06 info "nuts" field
  """
  def info do
    %{
      methods: [
        %__MODULE__{
          method: "bolt11",
          unit: "sat"
        }
      ],
      disabled: false
    }
  end
end
