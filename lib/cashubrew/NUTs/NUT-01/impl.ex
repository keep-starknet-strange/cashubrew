defmodule Cashubrew.Nuts.Nut01.Impl do
  @moduledoc """
  The mint logic for handling Nut01
  """
  alias Cashubrew.Mint

  def active_keysets_with_keys do
    repo = Application.get_env(:cashubrew, :repo)
    keysets = Mint.get_active_keysets(repo)

    keysets_with_keys =
      Enum.map(keysets, fn keyset ->
        keys = Mint.get_keys_for_keyset(repo, keyset.id)

        %{id: keyset.id, unit: keyset.unit, keys: keys}
      end)

    keysets_with_keys
  end

  def keys_for_keyset_id(id) do
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
