defmodule Gakimint.Schema.Keyset do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  schema "keysets" do
    field(:private_keys, :map)
    field(:public_keys, :map)
    field(:active, :boolean, default: false)

    timestamps()
  end

  def changeset(keyset, attrs) do
    keyset
    |> cast(attrs, [:private_keys, :public_keys, :active])
    |> validate_required([:private_keys, :public_keys])
  end
end
