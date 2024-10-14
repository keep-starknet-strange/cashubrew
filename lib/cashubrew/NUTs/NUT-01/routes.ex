defmodule Cashubrew.Nuts.Nut01.Routes do
  @moduledoc """
  List the rest routes defined in the NUT-01
  """

  @doc """
  The route to query active keys from the Mint
  """
  def v1_keys do
    "/v1/keys"
  end
end
