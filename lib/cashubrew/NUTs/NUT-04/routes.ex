defmodule Cashubrew.Nuts.Nut04.Routes do
  @moduledoc """
  List the rest routes defined in the NUT-04
  """

  @doc """
  The route to ask the Mint for a quote
  """
  def v1_mint_quote do
    "/v1/mint/quote/:method"
  end

  @doc """
  The route to check a quote state
  """
  def v1_mint_quote_for_quote_id do
    v1_mint_quote() <> "/:quote_id"
  end

  @doc """
  The route proceed to the mint
  """
  def v1_mint do
    "/v1/mint/:method"
  end
end
