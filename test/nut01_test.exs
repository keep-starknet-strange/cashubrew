defmodule Cashubrew.Nuts.Nut01Test do
  use Cashubrew.Test.ConnCase
  alias Cashubrew.Nuts.Nut01

  test "active_keysets", %{conn: conn} do
    conn = get(conn, ~p"/api/v1/keys")
    data = json_response(conn, 200)

    keysets = Map.fetch!(data, "keysets")
    assert length(keysets) == 1
    [keyset | _] = keysets

    id = Map.fetch!(keyset, "id")
    unit = Map.fetch!(keyset, "unit")
    keys = Map.fetch!(keyset, "keys")

    assert unit == "sat"
    assert is_bitstring(id)
    assert is_map(keys)
    assert Map.has_key?(keys, "1")

    Enum.each(keys, fn {k, v} ->
      # The keys are 1, 2, 4, 8, ...
      {amount, ""} = Integer.parse(k, 10)

      if amount != 1 do
        assert rem(amount, 2) == 0
        assert Map.has_key?(keys, "#{div(amount, 2)}")
      end

      # The values are valid hex numbers
      {_, ""} = Integer.parse(v, 16)
    end)
  end
end
