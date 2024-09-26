defmodule Gakimint.Schema.MeltQuote do
  @moduledoc """
  Schema for a mint quote.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "melt_quote" do
    field(:request, :string)
    field(:unit, :string)
    field(:amount, :integer)  # Make sure to use the correct field name
    field(:fee_reserve, :integer)
    field(:expiry, :integer)
    field(:request_lookup_id, :string)

    timestamps()
  end

  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:request, :unit, :amount, :fee_reserve, :expiry, :request_lookup_id])
    |> validate_required([:request, :unit, :amount, :fee_reserve, :expiry, :request_lookup_id])
  end
end
