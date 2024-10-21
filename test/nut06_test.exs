defmodule Cashubrew.Nuts.Nut06Test do
  use Cashubrew.Test.ConnCase

  test "info", %{conn: conn} do
    conn = get(conn, ~p"/api/v1/info")
    data = json_response(conn, 200)

    assert Map.has_key?(data, "contact")
    assert Map.has_key?(data, "nuts")
    assert Map.has_key?(data, "pubkey")
  end
end
