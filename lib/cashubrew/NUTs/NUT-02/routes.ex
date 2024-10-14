defmodule Cashubrew.Nuts.Nut02.Routes do
  alias Cashubrew.Nuts.Nut01

  @moduledoc """
  List the rest routes defined in the NUT-02
  """

  @doc """
  The route to query keys part of a specific keyset from the Mint
  """
  def v1_keys_for_keyset_id do
    Nut01.Routes.v1_keys() <> "/:keyset_id"
  end

  def v1_keyset do
    "/v1/keysets"
  end
end
