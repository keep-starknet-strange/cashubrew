defmodule Cashubrew.Test.ConnCase do
  @moduledoc """
  This module defines helpers to be used by tests that require an http connection.
  It also starts a sandboxed database connection.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint Cashubrew.Web.Endpoint

      use Cashubrew.Web, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import Cashubrew.Test.ConnCase
    end
  end

  setup tags do
    Cashubrew.Test.ConnCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Cashubrew.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)

  end
end
