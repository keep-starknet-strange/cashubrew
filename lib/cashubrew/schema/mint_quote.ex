defmodule Cashubrew.Schema.MintQuote do
  @moduledoc """
  Schema for a mint quote.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "mint_quotes" do
    field(:payment_request, :string)
    field(:expiry, :integer)
    field(:state, :string, default: "UNPAID")

    timestamps()
  end

  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:id, :payment_request, :expiry, :state])
    |> validate_required([:id, :payment_request, :expiry, :state])
    |> validate_inclusion(:state, ["UNPAID", "PAID", "ISSUED"])
  end

  def create!(repo, values) do
    %__MODULE__{}
    |> changeset(values)
    |> repo.insert()
    |> case do
      {:ok, _} -> nil
      {:error, changeset} -> raise "Failed to insert key: #{inspect(changeset.errors)}"
    end
  end
end
