defmodule Cashubrew.Nuts.Nut02.Impl do
  @moduledoc """
  The mint logic for handling Nut02
  """
  alias Cashubrew.Mint

  def keysets do
    repo = Application.get_env(:cashubrew, :repo)
    Mint.get_all_keysets(repo)
  end

  def keys_for_keyset_id!(id) do
    repo = Application.get_env(:cashubrew, :repo)
    keyset = Mint.get_keyset(repo, id)

    if keyset do
      keys = Mint.get_keys_for_keyset(repo, id)
      %{id: keyset.id, unit: keyset.unit, keys: keys}
    else
      raise "KeysetDoesNotExist"
    end
  end
end
