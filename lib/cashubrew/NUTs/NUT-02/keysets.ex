defmodule Cashubrew.Nuts.Nut02.Keyset do
  @moduledoc """
  Contains the logic required for the Mint to generate keys and keysets
  """
  alias Cashubrew.Nuts.Nut00.BDHKE
  import Bitwise

  def max_order do
    64
  end

  defp keyset_id_version do
    "00"
  end

  @doc """
  Generates a keyset from a seed and derivation path.

  ## Parameters

    - seed: A binary representing the seed.
    - derivation_path: A string representing the derivation path (e.g., "m/0'/0'/0'").

  ## Returns

    - A map containing amounts mapped to their corresponding private and public keys.
  """
  def generate_keys(seed, derivation_path) do
    encoded_seed =
      seed
      |> :unicode.characters_to_binary(:utf8)
      |> Base.encode16(case: :lower)

    {master_private_key, master_chain_code} = BlockKeys.CKD.master_keys(encoded_seed)
    root_key = BlockKeys.CKD.master_private_key({master_private_key, master_chain_code})

    Enum.map(0..(max_order() - 1), fn i ->
      amount = 1 <<< i
      child_path = "#{derivation_path}/#{i}"
      child_key = BlockKeys.CKD.derive(root_key, child_path)

      private_key = BlockKeys.Encoding.decode_extended_key(child_key)
      private_key_bytes = :binary.part(private_key.key, 1, 32)

      {_, public_key} = BDHKE.generate_keypair(private_key_bytes)

      %{
        amount: amount,
        private_key: private_key_bytes,
        public_key: public_key
      }
    end)
  end

  @spec derive_keyset_id([map()]) :: <<_::16, _::_*8>>
  @doc """
  Derives a keyset ID from a set of public keys.

  ## Parameters

    - keys: A list of maps containing public keys.

  ## Returns

    - A string representing the keyset ID.
  """
  def derive_keyset_id(keys) do
    sorted_keys = Enum.sort_by(keys, & &1.amount)
    pubkeys_concat = Enum.map(sorted_keys, & &1.public_key) |> IO.iodata_to_binary()

    keyset_id_version() <>
      (:crypto.hash(:sha256, pubkeys_concat) |> Base.encode16(case: :lower) |> binary_part(0, 14))
  end
end

# TODO: add logic for wallet to handle fees
# https://cashubtc.github.io/nuts/02/#fees
