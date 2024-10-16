defmodule Cashubrew.Schema.Promises do
  @moduledoc """
  Register a promise emited by the Mint
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:b, :string, autogenerate: false}
  schema "used_proof" do
    field(:keyset_id, :string)
    field(:amount, :integer)
    field(:c, :string)
    field(:e, :string)
    field(:s, :string)

    timestamps()
  end

  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:b, :keyset_id, :amount, :c, :e, :s])
    |> validate_required([:b, :keyset_id, :amount, :c, :e, :s])
  end
end
