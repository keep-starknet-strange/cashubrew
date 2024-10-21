defmodule Cashubrew.Schema.Keyset do
  @moduledoc """
  Keyset schema for the Cashubrew mint.
  """
  use Ecto.Schema
  import Ecto.Changeset
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

  def register_keyset(keys, unit, input_fee_ppk) do
    id = Cashubrew.Nuts.Nut02.Keysets.derive_keyset_id(keys)

    keyset = %__MODULE__{
      id: id,
      active: true,
      unit: unit,
      input_fee_ppk: input_fee_ppk
    }

    repo = Application.get_env(:cashubrew, :repo)

    case repo.insert(keyset) do
      {:ok, keyset} ->
        Schema.Key.insert_keys(repo, keys, id)
        keyset

      {:error, changeset} ->
        raise "Failed to insert keyset: #{inspect(changeset.errors)}"
    end
  end

  # Todo: create rotate function
end
