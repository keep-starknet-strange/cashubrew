# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Gakimint.Repo.insert!(%Gakimint.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# For now, let's just add a log message
IO.puts "No seed data to insert."

# You can add actual seed data here later if needed
# Example:
# alias Gakimint.Repo
# alias Gakimint.Schema.Keyset
#
# unless Repo.get_by(Keyset, active: true) do
#   Gakimint.Mint.create_new_keyset()
# end
