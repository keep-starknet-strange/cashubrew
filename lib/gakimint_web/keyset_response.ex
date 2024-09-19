defmodule GakimintWeb.KeysetResponse do
  @derive Jason.Encoder
  defstruct [:id, :unit, :keys]
end
