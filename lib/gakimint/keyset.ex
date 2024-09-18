defmodule Gakimint.Keyset do
  @moduledoc """
  Represents a keyset for the Gakimint mint.
  """

  @type t :: %__MODULE__{
          id: map(),
          private_keys: map(),
          public_keys: map(),
          active: boolean()
        }

  defstruct [:id, :private_keys, :public_keys, :active]

  @doc """
  Derive the keyset id from the public keys.
  """
  def derive_keyset_id(keys) do
    keys
    |> Enum.sort_by(fn {amount, _} -> amount end)
    |> Enum.map(fn {_, pubkey} -> Base.decode16!(pubkey, case: :mixed) end)
    |> Enum.reduce(<<>>, fn pubkey, acc -> acc <> pubkey end)
    |> (&:crypto.hash(:sha256, &1)).()
    |> Base.encode16(case: :lower)
    |> (&("00" <> binary_part(&1, 0, 14))).()
  end
end
