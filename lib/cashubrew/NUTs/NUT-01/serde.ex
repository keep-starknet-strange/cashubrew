defmodule Cashubrew.Nuts.Nut01.Serde.GetKeysResponse do
  @moduledoc """
  The body of the get keys rest response
  """
  @derive Jason.Encoder
  @enforce_keys [:keysets]
  defstruct [:keysets]

  def from_keysets(keysets) do
    %__MODULE__{keysets: inner_from_keysets(keysets, [])}
  end

  defp inner_from_keysets([], accumulator) do
    accumulator
  end

  defp inner_from_keysets([%{id: id, unit: unit, keys: keys} | tail], accumulator) do
    inner_from_keysets(tail, [
      Cashubrew.Nuts.Nut01.Serde.Keyset.from_keyset(id, unit, keys) | accumulator
    ])
  end
end

defmodule Cashubrew.Nuts.Nut01.Serde.Keys do
  @moduledoc """
  Keys for the Cashubrew mint.
  """
  defstruct [:pairs]
end

defimpl Jason.Encoder, for: Cashubrew.Nuts.Nut01.Serde.Keys do
  def encode(%Cashubrew.Nuts.Nut01.Serde.Keys{pairs: pairs}, opts) do
    # Convert amounts to strings and sort them in ascending order
    sorted_pairs =
      pairs
      |> Enum.map(fn {amount, pubkey} -> {to_string(amount), pubkey} end)
      |> Enum.sort_by(
        fn {amount_str, _} ->
          {amount_int, ""} = Integer.parse(amount_str)
          amount_int
        end,
        :asc
      )

    # Encode the sorted pairs as JSON
    json_pairs =
      sorted_pairs
      |> Enum.map(fn {key, value} ->
        [Jason.Encode.string(key, opts), ?:, Jason.Encode.string(value, opts)]
      end)

    json_pairs = Enum.intersperse(json_pairs, ?,)
    ["{", json_pairs, "}"]
  end
end

defmodule Cashubrew.Nuts.Nut01.Serde.Keyset do
  @moduledoc """
  A keyset
  """
  @derive Jason.Encoder
  @enforce_keys [:id, :unit, :keys]
  defstruct [:id, :unit, :keys]

  def from_keyset(id, unit, keys) do
    keys_list =
      Enum.map(keys, fn key -> {key.amount, Base.encode16(key.public_key, case: :lower)} end)

    %__MODULE__{
      id: id,
      unit: unit,
      keys: %Cashubrew.Nuts.Nut01.Serde.Keys{pairs: keys_list}
    }
  end
end
