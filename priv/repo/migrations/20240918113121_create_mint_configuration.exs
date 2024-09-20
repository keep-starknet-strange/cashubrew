defmodule Gakimint.Repo.Migrations.CreateMintConfiguration do
  use Ecto.Migration

  def change do
    create table(:mint_configuration) do
      add :key, :string, null: false
      add :value, :string, null: false

      timestamps()
    end

    create unique_index(:mint_configuration, [:key])
  end
end
