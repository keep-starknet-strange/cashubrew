defmodule Cashubrew.Repo.Migrations.CreateMeltQuote do
  use Ecto.Migration

  def change do
    create table(:melt_quote, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :request, :string, null: false
      add :unit, :string, null: false
      add :amount, :integer, null: false
      add :fee_reserve, :integer, null: false
      add :expiry, :integer, null: false
      add :request_lookup_id, :string, null: false

      timestamps()
    end
  end
end
