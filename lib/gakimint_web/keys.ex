defmodule GakimintWeb.Keys do
  defstruct [:pairs]
end

defimpl Jason.Encoder, for: GakimintWeb.Keys do
  def encode(%GakimintWeb.Keys{pairs: pairs}, opts) do
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
