defmodule Cashubrew.Web.KeysetResponse do
  @moduledoc """
  Keyset response for the Cashubrew mint.
  """
  @derive Jason.Encoder
  defstruct [:id, :unit, :keys]
end
