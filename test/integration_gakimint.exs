defmodule Gakimint.Integration do
  use ExUnit.Case, async: true
  alias Gakimint.Cashu.TokenV4

  describe "V4 Token" do
    @tag :v4_token
    test "serialization and deserialization" do
      token = %{
        m: "https://example.com",
        u: "sat",
        d: "Test token",
        t: [
          %{
            i: <<1, 2, 3>>,
            p: [
              %{
                a: 10,
                s: "secret1",
                c: <<4, 5, 6>>,
                d: %{e: <<7, 8, 9>>, s: <<10, 11, 12>>, r: <<13, 14, 15>>},
                w: "witness1"
              },
              %{
                a: 20,
                s: "secret2",
                c: <<16, 17, 18>>,
                w: "witness2"
              }
            ]
          }
        ]
      }

      serialized = TokenV4.serialize(token)
      assert String.starts_with?(serialized, "cashuB")

      {:ok, deserialized} = TokenV4.deserialize(serialized)
      assert normalize_token(deserialized) == normalize_token(token)
    end

    test "deserialization of invalid token" do
      assert {:error, "Invalid token format"} = TokenV4.deserialize("invalid_token")
      assert {:error, "Invalid CBOR in token"} = TokenV4.deserialize("cashuBinvalid_base64")

      assert {:error, "Invalid CBOR in token"} =
               TokenV4.deserialize("cashuB" <> Base.url_encode64(<<1, 2, 3>>, padding: false))
    end
  end

  # Helper function to normalize binary representations
  defp normalize_token(token) do
    token
    |> normalize_binary_keys([:i, :c, :e, :s, :r])
  end

  defp normalize_binary_keys(map, keys) when is_map(map) do
    Enum.reduce(keys, map, fn key, acc ->
      if Map.has_key?(acc, key) do
        Map.update!(acc, key, &normalize_binary/1)
      else
        acc
      end
    end)
    |> Map.new(fn {k, v} -> {k, normalize_binary_keys(v, keys)} end)
  end

  defp normalize_binary_keys(list, keys) when is_list(list) do
    Enum.map(list, &normalize_binary_keys(&1, keys))
  end

  defp normalize_binary_keys(value, _keys), do: value

  defp normalize_binary(value) when is_binary(value), do: Base.encode16(value, case: :lower)
  defp normalize_binary(value), do: value
end
