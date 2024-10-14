defmodule Cashubrew.Schema.Key do
  @moduledoc """
  Key schema for the Cashubrew mint.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Cashubrew.Types.BigInteger

  schema "keys" do
    field(:keyset_id, :string)
    field(:amount, BigInteger)
    field(:private_key, :binary)
    field(:public_key, :binary)

    timestamps()
  end

  def changeset(key, attrs) do
    key
    |> cast(attrs, [:keyset_id, :amount, :private_key, :public_key])
    |> validate_required([:keyset_id, :amount, :private_key, :public_key])
  end

  def insert_keys(repo, keys, keyset_id) do
    Enum.each(keys, fn key ->
      key
      |> Map.put(:keyset_id, keyset_id)
      |> insert_key(repo)
    end)
  end

  defp insert_key(key, repo) do
    %__MODULE__{}
    |> changeset(key)
    |> repo.insert()
    |> case do
      {:ok, _} -> :ok
      {:error, changeset} -> raise "Failed to insert key: #{inspect(changeset.errors)}"
    end
  end
end
