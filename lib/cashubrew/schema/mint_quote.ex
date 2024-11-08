defmodule Cashubrew.Schema.MintQuote do
  @moduledoc """
  Schema for a mint quote.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "mint_quotes" do
    field(:r_hash, :binary)
    field(:payment_request, :string)
    field(:add_index, :integer)
    field(:payment_addr, :binary)
    field(:description, :string)
    # 0 -> "UNPAID", 1 -> "PAID", 2 -> "ISSUED"
    # The msb is used as a guard against two process minting this quote at the same time.
    # It has to be set when we start the minting process and cleared in the end,
    # regardless of the mint being a succes or a failure.
    field(:state, :binary)

    timestamps()
  end

  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [
      :id,
      :r_hash,
      :payment_request,
      :add_index,
      :payment_addr,
      :description,
      :state
    ])
    |> validate_required([:id, :r_hash, :payment_request, :add_index, :payment_addr, :state])
    |> validate_inclusion(:state, [<<0>>, <<1>>, <<2>>, <<128>>, <<129>>, <<130>>])
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

  def unset_pending(repo, id) do
    value = repo.get(__MODULE__, id)
    is_pending = Bitwise.band(value.state, Bitwise.bsl(<<0x80>>, 7)) != 0

    if is_pending do
      new_state = value.state && <<0x7F>>
      new_value = Ecto.Changeset.change(value, state: new_state)

      case repo.update(new_value) do
        {:ok, _} -> {:ok, value.state}
        {:error, changeset} -> {:error, "Failed to update key: #{inspect(changeset.errors)}"}
      end
    else
      {:ok, value.state}
    end
  end
end
