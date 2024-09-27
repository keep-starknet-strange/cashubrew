defmodule Cashubrew.Test.Mint do
  use ExUnit.Case, async: true
  alias Cashubrew.Mint

  describe "Mint quote" do
    @tag :mint_quote

    test "Mint quote" do
      IO.puts("Mint quote")

      {:ok, mint}= Mint.create_mint_quote(1, "lfg")

    end

  end
  defp normalize_binary(value) when is_binary(value), do: Base.encode16(value, case: :lower)
  defp normalize_binary(value), do: value
end
