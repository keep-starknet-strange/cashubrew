defmodule Cashubrew.Repo do
  use Ecto.Repo,
    otp_app: :cashubrew,
    adapter: Ecto.Adapters.Postgres
end
