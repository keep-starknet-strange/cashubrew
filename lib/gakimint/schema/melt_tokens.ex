defmodule Gakimint.Schema.MeltTokens do
  @moduledoc """
  Schema for a mint quote.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "melt_tokens" do
    field(:request, :string)
    field(:unit, :string)
    field(:amount, :integer)
    field(:fee_reserve, :integer)
    field(:expiry, :integer)
    field(:request_lookup_id, :string)

    timestamps()
  end

  def changeset(melt_tokens, attrs) do
    melt_tokens
    |> cast(attrs, [:request, :unit, :amount, :fee_reserve, :expiry, :request_lookup_id])
    |> validate_required([:request, :unit, :amount, :fee_reserve, :expiry, :request_lookup_id])
  end
end
