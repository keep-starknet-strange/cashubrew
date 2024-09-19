defmodule Gakimint.Repo.Migrations.CreateKeys do
  use Ecto.Migration

  def change do
    create table(:keys) do
      add :keyset_id, references(:keysets, type: :string, on_delete: :delete_all), null: false
      add :amount, :string, null: false
      add :private_key, :binary, null: false
      add :public_key, :string, null: false

      timestamps()
    end

    create index(:keys, [:keyset_id])
  end
end
