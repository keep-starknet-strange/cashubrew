defmodule Gakimint.Schema.Keyset do
  @moduledoc """
  Keyset schema for the Gakimint mint.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Gakimint.{Crypto.BDHKE, Repo, Schema}

  import Bitwise
  @max_order 64

  @primary_key {:id, :string, autogenerate: false}
  schema "keysets" do
    field(:active, :boolean, default: true)
    field(:unit, :string)
    field(:input_fee_ppk, :integer)
    timestamps()
  end

  def changeset(keyset, attrs) do
    keyset
    |> cast(attrs, [:id, :active, :unit, :input_fee_ppk])
    |> validate_required([:id, :unit])
  end

  @spec generate(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) :: any()
  def generate(unit \\ "sat", seed, derivation_path \\ "m/0'/0'/0'", input_fee_ppk \\ 0) do
    keys = generate_keys(seed, derivation_path)
    id = derive_keyset_id(keys)

    keyset = %__MODULE__{
      id: id,
      active: true,
      unit: unit,
      input_fee_ppk: input_fee_ppk
    }

    {:ok, keyset} = Repo.insert(keyset)

    # Insert keys into the database
    Enum.each(keys, fn key ->
      key = Map.put(key, :keyset_id, id)

      %Schema.Key{}
      |> Schema.Key.changeset(key)
      |> Repo.insert!()
    end)

    keyset
  end

  @doc """
  Generates a keyset from a seed and derivation path.

  ## Parameters

    - seed: A binary representing the seed.
    - derivation_path: A string representing the derivation path (e.g., "m/0'/0'/0'").

  ## Returns

    - A map containing amounts mapped to their corresponding private and public keys.
  """
  def generate_keys(seed, derivation_path \\ "m/0'/0'/0'") do
    # Encode the seed as utf-8 hex
    encoded_seed =
      seed
      |> :unicode.characters_to_binary(:utf8)
      |> Base.encode16(case: :lower)

    # Generate the master key from the seed
    {master_private_key, master_chain_code} = BlockKeys.CKD.master_keys(encoded_seed)
    # Generate the master extended private key
    root_key = BlockKeys.CKD.master_private_key({master_private_key, master_chain_code})

    # Generate keys for amounts 2^i where i ranges from 0 to @max_order - 1
    Enum.map(0..(@max_order - 1), fn i ->
      amount = 1 <<< i
      # Child path is the derivation path concatenated with the index
      child_path = "#{derivation_path}/#{i}"
      child_key = BlockKeys.CKD.derive(root_key, child_path)

      # Get the private key
      private_key = BlockKeys.Encoding.decode_extended_key(child_key)
      # Remove the leading zero byte from the private key
      private_key_bytes = :binary.part(private_key.key, 1, 32)

      # Get the public key
      {_, public_key} = BDHKE.generate_keypair(private_key_bytes)

      %{
        amount: amount,
        private_key: private_key_bytes,
        public_key: public_key
      }
    end)
  end

  @spec derive_keyset_id(any()) :: <<_::16, _::_*8>>
  @doc """
  Derives a keyset ID from a set of public keys.

  ## Parameters

    - keys: A map of amounts to public keys.

  ## Returns

    - A string representing the keyset ID.
  """
  def derive_keyset_id(keys) do
    sorted_keys = Enum.sort_by(keys, fn key -> key.amount end)
    pubkeys_concat = Enum.map(sorted_keys, fn key -> key.public_key end) |> IO.iodata_to_binary()

    "00" <>
      (:crypto.hash(:sha256, pubkeys_concat) |> Base.encode16(case: :lower) |> binary_part(0, 14))
  end
end
