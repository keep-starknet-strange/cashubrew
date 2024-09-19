defmodule Gakimint.Schema.Key do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keys" do
    field(:keyset_id, :string)
    field(:amount, :string)
    field(:private_key, :binary)
    field(:public_key, :string)

    timestamps()
  end

  def changeset(key, attrs) do
    key
    |> cast(attrs, [:keyset_id, :amount, :private_key, :public_key])
    |> validate_required([:keyset_id, :amount, :private_key, :public_key])
  end
end
