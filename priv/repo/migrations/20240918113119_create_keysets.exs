defmodule Cashubrew.Repo.Migrations.CreateKeysets do
  use Ecto.Migration

  def change do
    create table(:keysets, primary_key: false) do
      add :id, :string, primary_key: true
      add :active, :boolean, default: true
      add :unit, :string
      add :input_fee_ppk, :integer
      timestamps()
    end
  end
end
