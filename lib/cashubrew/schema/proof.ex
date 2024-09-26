defmodule Cashubrew.Schema.Proof do
  @moduledoc """
  Schema for a mint quote.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "proof" do
    field(:quote_id, :string)
    field(:secret, :string)
    field(:amount, :integer)
    field(:y, :string)
    field(:c, :string)

    timestamps()
  end

  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:quote_id, :secret, :amount, :y, :c])
    |> validate_required([:quote_id, :secret, :amount, :y, :c])
  end
end
