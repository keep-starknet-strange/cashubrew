defmodule Gakimint.Schema.Payment do
  @moduledoc """
  Schema for a payment.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field(:amount, :integer)
    field(:payment_hash, :string)
    field(:state, :string, default: "PENDING")

    timestamps()
  end

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :payment_hash, :state])
    |> validate_required([:amount, :payment_hash, :state])
    |> validate_inclusion(:state, ["PENDING", "COMPLETED", "FAILED"])
  end
end
