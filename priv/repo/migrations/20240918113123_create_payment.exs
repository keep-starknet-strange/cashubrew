defmodule Cashubrew.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount, :integer, null: false
      add :payment_hash, :string, null: false
      add :state, :string, default: "PENDING", null: false

      timestamps()
    end
  end
end
