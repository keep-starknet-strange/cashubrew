defmodule Cashubrew.Schema.MeltQuote do
  @moduledoc """
  Schema for a mint quote.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "melt_quote" do
    field(:request, :string)
    field(:unit, :string)
    # Make sure to use the correct field name
    field(:amount, :integer)
    field(:fee_reserve, :integer)
    field(:expiry, :integer)
    field(:request_lookup_id, :string)

    timestamps()
  end

  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:id, :request, :unit, :amount, :fee_reserve, :expiry, :request_lookup_id])
    |> validate_required([
      :id,
      :request,
      :unit,
      :amount,
      :fee_reserve,
      :expiry,
      :request_lookup_id
    ])
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
