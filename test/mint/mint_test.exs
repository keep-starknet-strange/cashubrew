defmodule Gakimint.MintTest do
  use ExUnit.Case, async: true
  alias Gakimint.Mint
  alias Gakimint.Cashu.{BlindedMessage, BlindSignature}
  alias Gakimint.Schema.MintQuote

  # Ignore test for now
  @tag :skip
  test "mint_tokens successfully signs blinded messages" do
    quote = %MintQuote{
      id: 1,
      amount: 10,
      payment_request: "dummy_payment_request",
      state: "PAID",
      expiry: :os.system_time(:second) + 3600,
      description: "Test payment"
    }

    blinded_messages = [
      %BlindedMessage{
        amount: 8,
        id: "id1",
        B_: "0223b5b1d7c4e17d6dc6a6f0c9fae1d5a5e9260b9e5291e9024c6f1c1f6d4e5c68"
      },
      %BlindedMessage{
        amount: 2,
        id: "id2",
        B_: "03b6f6f8c6d8c1e1f2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6"
      }
    ]

    {:ok, signatures} = Mint.mint_tokens(quote, blinded_messages)

    assert length(signatures) == 2

    Enum.each(signatures, fn sig ->
      assert %BlindSignature{} = sig
      assert sig."C_" != nil
    end)
  end

  # Ignore test for now
  @tag :skip
  test "mint_tokens fails if quote is not paid" do
    quote = %MintQuote{
      id: 2,
      amount: 10,
      payment_request: "dummy_payment_request",
      state: "UNPAID",
      expiry: :os.system_time(:second) + 3600,
      description: "Test payment"
    }

    blinded_messages = [
      %BlindedMessage{
        amount: 10,
        id: "id1",
        B_: "0223b5b1d7c4e17d6dc6a6f0c9fae1d5a5e9260b9e5291e9024c6f1c1f6d4e5c68"
      }
    ]

    {:error, reason} = Mint.mint_tokens(quote, blinded_messages)

    assert reason == :payment_not_received
  end
end
