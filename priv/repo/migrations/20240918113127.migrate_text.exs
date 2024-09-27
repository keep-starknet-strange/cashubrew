defmodule Cashubrew.Repo.Migrations.ChangePaymentRequestToText do
  use Ecto.Migration

  def change do
    alter table(:mint_quotes) do
      modify :payment_request, :text, null: false
    end
  end
end
