defmodule Gakimint.Repo.Migrations.CreateKeysets do
  use Ecto.Migration

  def change do
    create table(:keysets, primary_key: false) do
      add :id, :string, primary_key: true
      add :private_keys, :map
      add :public_keys, :map
      add :active, :boolean, default: true
      add :unit, :string

      timestamps()
    end
  end
end
