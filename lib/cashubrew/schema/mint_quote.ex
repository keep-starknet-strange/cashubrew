defmodule Cashubrew.Schema.MintQuote do
  @moduledoc """
  Schema for a mint quote.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "mint_quotes" do
    field(:amount, :integer)
    field(:payment_request, :string)
    field(:state, :string, default: "UNPAID")
    field(:expiry, :integer)
    field(:description, :string)
    field(:payment_hash, :string)

    timestamps()
  end

  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:amount, :payment_request, :state, :expiry, :description, :payment_hash])
    |> validate_required([:amount, :payment_request, :state, :expiry])
    |> validate_inclusion(:state, ["UNPAID", "PAID", "ISSUED"])
  end
end
