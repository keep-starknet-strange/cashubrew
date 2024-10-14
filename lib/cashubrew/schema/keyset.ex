defmodule Cashubrew.Schema.Keyset do
  @moduledoc """
  Keyset schema for the Cashubrew mint.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Cashubrew.Nuts.Nut00.BDHKE
  alias Cashubrew.Schema

  import Bitwise

  defp max_order do
    64
  end

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

  def generate(unit \\ "sat", seed, derivation_path \\ "m/0'/0'/0'", input_fee_ppk \\ 0) do
    keys = generate_keys(seed, derivation_path)
    id = derive_keyset_id(keys)

    keyset = %__MODULE__{
      id: id,
      active: true,
      unit: unit,
      input_fee_ppk: input_fee_ppk
    }

    repo = Application.get_env(:cashubrew, :repo)

    case repo.insert(keyset) do
      {:ok, keyset} ->
        insert_keys(repo, keys, id)
        keyset

      {:error, changeset} ->
        raise "Failed to insert keyset: #{inspect(changeset.errors)}"
    end
  end

  defp insert_keys(repo, keys, keyset_id) do
    Enum.each(keys, fn key ->
      key
      |> Map.put(:keyset_id, keyset_id)
      |> insert_key(repo)
    end)
  end

  defp insert_key(key, repo) do
    %Schema.Key{}
    |> Schema.Key.changeset(key)
    |> repo.insert()
    |> case do
      {:ok, _} -> :ok
      {:error, changeset} -> raise "Failed to insert key: #{inspect(changeset.errors)}"
    end
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

    "00" <>
      (:crypto.hash(:sha256, pubkeys_concat) |> Base.encode16(case: :lower) |> binary_part(0, 14))
  end
end
