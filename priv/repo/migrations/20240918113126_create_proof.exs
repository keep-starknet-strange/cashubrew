defmodule Gakimint.Repo.Migrations.CreateProof do
  use Ecto.Migration

  def change do
    create table(:proof) do
      add :quote_id, :string, null: false
      add :secret, :string, null: false
      add :amount, :integer, null: false
      add :y, :string, null: false
      add :c, :string, null: false

      timestamps()
    end
  end
end
