defmodule Cashubrew.Nuts.Nut05.Routes do
  @moduledoc """
  List the rest routes defined in the NUT-05
  """

  @doc """
  The route to ask the melt for a quote
  """
  def v1_melt_quote do
    "/v1/melt/quote/:method"
  end

  @doc """
  The route to check a melt quote state
  """
  def v1_melt_quote_for_quote_id do
    v1_melt_quote() <> "/:quote_id"
  end

  @doc """
  The route proceed to the melt
  """
  def v1_melt do
    "/v1/melt/:method"
  end
end
