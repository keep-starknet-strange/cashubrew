defmodule Cashubrew.Repo.Migrations.ChangeMeltQuoteRequestTypeToText do
  use Ecto.Migration

  def change do
    alter table :melt_quote do
      modify :request, :text
    end
  end
end
