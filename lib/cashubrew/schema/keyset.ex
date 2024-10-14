defmodule Cashubrew.Schema.Keyset do
  @moduledoc """
  Keyset schema for the Cashubrew mint.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Cashubrew.Nuts.Nut01.Keyset
  alias Cashubrew.Schema

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
    keys = Keyset.generate_keys(seed, derivation_path)
    id = Keyset.derive_keyset_id(keys)

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
end
