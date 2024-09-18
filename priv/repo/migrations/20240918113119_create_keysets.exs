defmodule Gakimint.Repo.Migrations.CreateKeysets do
  use Ecto.Migration

  def change do
    create table(:keysets, primary_key: false) do
      add :id, :string, primary_key: true
      add :private_keys, :map, null: false
      add :public_keys, :map, null: false
      add :active, :boolean, default: false, null: false

      timestamps()
    end

    create index(:keysets, [:active])
  end
end
