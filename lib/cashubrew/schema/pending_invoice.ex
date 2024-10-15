defmodule Cashubrew.Schema.PendingInvoice do
  @moduledoc """
  Schema for a mint quote.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "pending_invoices" do
    field(:amount, :integer)
    field(:payment_request, :string)

    timestamps()
  end

  def changeset(pending_invoice, attrs) do
    pending_invoice
    |> cast(attrs, [:amount, :payment_request])
    |> validate_required([:amount, :payment_request])
  end

  def create!(repo, values) do
    %__MODULE__{}
    |> changeset(values)
    |> repo.insert()
    |> case do
      {:ok, pending_invoice} -> pending_invoice.id
      {:error, changeset} -> raise "Failed to insert key: #{inspect(changeset.errors)}"
    end
  end
end
