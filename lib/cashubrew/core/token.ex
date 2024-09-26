defmodule Cashubrew.Cashu.Token do
  @moduledoc """
  Handles the serialization and deserialization of Cashu tokens.
  """
  alias CBOR
  alias Cashubrew.Cashu.Proof

  @type v3_token :: %{
          token: [%{mint: String.t(), proofs: [Proof.t()]}],
          unit: String.t() | nil,
          memo: String.t() | nil
        }

  @doc """
  Serializes a V3 token to a string.
  """
  @spec serialize_v3(v3_token()) :: String.t()
  def serialize_v3(token) do
    json = Jason.encode!(token)
    base64 = Base.url_encode64(json, padding: false)
    "cashuA#{base64}"
  end

  @doc """
  Deserializes a V3 token string to a token struct.
  """
  @spec deserialize_v3(String.t()) :: {:ok, v3_token()} | {:error, String.t()}
  def deserialize_v3("cashuA" <> base64) do
    case Base.url_decode64(base64, padding: false) do
      {:ok, json} ->
        case Jason.decode(json) do
          {:ok, token} -> {:ok, token}
          {:error, _} -> {:error, "Invalid JSON in token"}
        end

      :error ->
        {:error, "Invalid base64 encoding"}
    end
  end

  def deserialize_v3(_), do: {:error, "Invalid token format"}
end

defmodule Cashubrew.Cashu.TokenV4 do
  @moduledoc """
  Handles the serialization and deserialization of Cashu V4 tokens.
  """

  @type v4_token :: %{
          m: String.t(),
          u: String.t() | nil,
          d: String.t() | nil,
          t: [
            %{
              i: binary(),
              p: [
                %{
                  a: non_neg_integer(),
                  s: String.t(),
                  c: binary(),
                  d: %{e: binary(), s: binary(), r: binary()} | nil,
                  w: String.t() | nil
                }
              ]
            }
          ]
        }

  @doc """
  Serializes a V4 token to a string.
  """
  @spec serialize(v4_token()) :: String.t()
  def serialize(token) do
    cbor = CBOR.encode(token)
    base64 = Base.url_encode64(cbor, padding: false)
    "cashuB#{base64}"
  end

  @doc """
  Deserializes a V4 token string to a token struct.
  """
  @spec deserialize(String.t()) :: {:ok, v4_token()} | {:error, String.t()}
  def deserialize("cashuB" <> base64) do
    case Base.url_decode64(base64, padding: false) do
      {:ok, cbor} ->
        case CBOR.decode(cbor) do
          {:ok, token, ""} -> {:ok, keys_to_atoms(token)}
          _ -> {:error, "Invalid CBOR in token"}
        end

      :error ->
        {:error, "Invalid base64 encoding"}
    end
  end

  def deserialize(_), do: {:error, "Invalid token format"}

  defp keys_to_atoms(map) when is_map(map) do
    Map.new(map, fn
      {key, value} when is_binary(key) -> {String.to_existing_atom(key), keys_to_atoms(value)}
      {key, value} -> {key, keys_to_atoms(value)}
    end)
  end

  defp keys_to_atoms(list) when is_list(list) do
    Enum.map(list, &keys_to_atoms/1)
  end

  defp keys_to_atoms(value), do: value
end
