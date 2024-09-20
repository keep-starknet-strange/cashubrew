defmodule Gakimint.Web.KeysetResponse do
  @moduledoc """
  Keyset response for the Gakimint mint.
  """
  @derive Jason.Encoder
  defstruct [:id, :unit, :keys]
end
