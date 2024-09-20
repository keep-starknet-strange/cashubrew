# lib/gakimint/schema/mint_configuration.ex
defmodule Gakimint.Schema.MintConfiguration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mint_configuration" do
    field(:key, :string)
    field(:value, :string)

    timestamps()
  end

  def changeset(config, attrs) do
    config
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
    |> unique_constraint(:key)
  end
end
