defmodule Cashubrew.Schema.UsedProof do
  @moduledoc """
  Register the proof used by the Mint.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "used_proof" do
    field(:keyset_id, :string)
    field(:amount, :integer)
    field(:secret, :string)
    field(:c, :string)
  end

  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:keyset_id, :amount, :secret, :c])
    |> validate_required([:keyset_id, :amount, :secret, :c])
  end
end
