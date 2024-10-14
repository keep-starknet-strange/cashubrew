defmodule Cashubrew.Nuts.Nut03.Routes do
  @moduledoc """
  List the rest routes defined in the NUT-03
  """

  @doc """
  The route to ask the Mint for token swap
  """
  def v1_swap do
    "/v1/swap"
  end
end
