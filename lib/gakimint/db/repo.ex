defmodule Gakimint.Repo do
  use Ecto.Repo,
    otp_app: :gakimint,
    adapter: Ecto.Adapters.Postgres
end
