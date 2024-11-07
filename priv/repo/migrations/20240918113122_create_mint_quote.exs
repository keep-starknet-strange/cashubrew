defmodule Cashubrew.Repo.Migrations.CreateMintQuote do
  use Ecto.Migration

  def change do
    create table(:mint_quotes) do
      add :amount, :integer, null: false
      add :payment_request, :text, null: false
      add :state, :binary, null: false, default: fragment("decode('00', 'hex')")
      add :expiry, :integer, null: false
      add :description, :string
      add :payment_hash, :string
      add :unit, :string

      timestamps()
    end
  end
end
