defmodule Cashubrew.Nuts.Nut02Test do
  use Cashubrew.Test.ConnCase
  alias Cashubrew.Schema.Key
  alias Cashubrew.Schema.Keyset
  alias Cashubrew.Repo

  test "get all keysets", %{conn: conn} do
    data = conn |> get(~p"/api/v1/keysets") |> json_response(200)

    [keyset] = data["keysets"]
    assert Map.has_key?(keyset, "id")
    assert keyset["id"] |> String.starts_with?("00")
    assert keyset["unit"] == "sat"
    assert keyset["active"] == true
  end

  test "get 2 keysets", %{conn: conn} do
    pub_keys = [
      %{amount: 1, public_key: "pub_01", private_key: "priv_01"},
      %{amount: 2, public_key: "pub_02", private_key: "priv_02"},
      %{amount: 3, public_key: "pub_03", private_key: "priv_03"},
      %{amount: 4, public_key: "pub_04", private_key: "priv_04"}
    ]

    id = Cashubrew.Nuts.Nut02.Keysets.derive_keyset_id(pub_keys)

    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    pub_keys =
      Enum.map(pub_keys, fn key ->
        key
        |> Map.put(:keyset_id, id)
        |> Map.put(:inserted_at, now)
        |> Map.put(:updated_at, now)
      end)

    Repo.insert!(%Keyset{id: id, unit: "sat", active: false})
    Repo.insert_all(Key, pub_keys)

    data = conn |> get(~p"/api/v1/keysets") |> json_response(200)

    [keyset1, keyset2] = data["keysets"]

    assert Map.has_key?(keyset1, "id")
    assert keyset1["id"] |> String.starts_with?("00")
    assert keyset1["unit"] == "sat"
    assert keyset1["active"] == true

    assert Map.has_key?(keyset2, "id")
    assert keyset2["id"] |> String.starts_with?("00")
    assert keyset2["id"] == id
    assert keyset2["unit"] == "sat"
    assert keyset2["active"] == false
  end

  test "get one keyset", %{conn: conn} do
    data = conn |> get(~p"/api/v1/keysets") |> json_response(200)

    [keyset] = data["keysets"]
    id = keyset["id"]

    data = conn |> get(~p"/api/v1/keys/#{id}") |> json_response(200)
    [keyset] = data["keysets"]

    assert keyset["id"] == id
    assert map_size(keyset["keys"]) > 0
  end
end
