defmodule Gakimint.Repo.Migrations.CreateMeltQuoteResponse do
  use Ecto.Migration

  def change do
    create table(:melt_tokens) do
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