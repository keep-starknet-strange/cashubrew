defmodule Cashubrew.Query.MeltTokens do
  import Ecto.Query, warn: false
  alias Cashubrew.Repo
  alias Cashubrew.Schema.MeltTokens

  # Fetch all users
  def list_melt_tokens do
    Repo.all(MeltTokens)
  end

  # Fetch a quote by id
  def get_melt_by_quote_id!(quote_id) do
    query =
      from(u in MeltTokens,
        where: u.request == ^quote_id,
        select: u
      )

    # Return a single user (or nil if no match)
    Repo.one(query)
  end
end
