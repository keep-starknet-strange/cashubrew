defmodule Cashubrew.Repo.Migrations.CreateMintQuote do
  use Ecto.Migration

  def change do
    create table(:mint_quotes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :r_hash, :binary, null: false
      add :payment_request, :text, null: false
      add :add_index, :integer, null: false
      add :payment_addr, :binary, null: false
      add :description, :string
      add :state, :binary, null: false, default: fragment("decode('00', 'hex')")

      timestamps()
    end
  end
end
