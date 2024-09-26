defmodule Cashubrew.Schema.Key do
  @moduledoc """
  Key schema for the Cashubrew mint.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Cashubrew.Types.BigInteger

  schema "keys" do
    field(:keyset_id, :string)
    field(:amount, BigInteger)
    field(:private_key, :binary)
    field(:public_key, :binary)

    timestamps()
  end

  def changeset(key, attrs) do
    key
    |> cast(attrs, [:keyset_id, :amount, :private_key, :public_key])
    |> validate_required([:keyset_id, :amount, :private_key, :public_key])
  end
end
