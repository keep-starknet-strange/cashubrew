# lib/cashubrew/schema/mint_configuration.ex
defmodule Cashubrew.Schema.MintConfiguration do
  @moduledoc """
  Mint configuration for the Cashubrew mint.
  """
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
