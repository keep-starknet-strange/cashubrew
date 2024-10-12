defmodule Cashubrew.Mint.SwapTest do
  use ExUnit.Case, async: true

  alias Cashubrew.Crypto.BDHKE
  alias Cashubrew.PostSwapRequest
  alias Cashubrew.Schema.Keyset
  alias Cashubrew.Mint

  setup do
    {:ok, mint_genserver} = GenServer.start_link(Cashubrew.Mint, %{})
    [keyset] = Mint.get_keysets()
    all_amounts = Mint.get_keys_for_keyset(Cashubrew.Repo, keyset.id)
    amount_1 = Enum.filter(all_amounts, fn k -> k.amount == 1 end) |> List.first()

    x = :crypto.strong_rand_bytes(32)
    r = :crypto.strong_rand_bytes(32)

    {b_, _} = BDHKE.step1_alice(x, r)
    {c_, _, _} = BDHKE.step2_bob(b_, amount_1.private_key)
    c = BDHKE.step3_alice(c_, r, amount_1.public_key)

    proof =
      Cashubrew.Cashu.Proof.new(
        1,
        keyset.id,
        x,
        c
      )

    %{x: x, r: r, proof: proof, amount_1: amount_1, mint_genserver: mint_genserver}
  end

  test "it works", %{x: x, r: r, proof: proof, mint_genserver: mint_genserver, amount_1: amount_1} do
    new_x = :crypto.strong_rand_bytes(32)
    new_r = :crypto.strong_rand_bytes(32)

    {new_b_, _} = BDHKE.step1_alice(new_x, new_r)

    blinded_message =
      Cashubrew.Cashu.BlindedMessage.new_blinded_message(
        1,
        amount_1.keyset_id,
        Base.encode16(new_b_, case: :lower)
      )

    {expected_c_, _e, _s} = BDHKE.step2_bob(new_b_, amount_1.private_key)

    post_swap_request = PostSwapRequest.new([proof], [blinded_message])

    {:ok, [actual_blind_signature]} = Mint.swap(mint_genserver, post_swap_request)

    assert actual_blind_signature."C_" == Base.encode16(expected_c_, case: :lower)
    assert actual_blind_signature.amount == 1
    assert actual_blind_signature.id == blinded_message.id
  end
end
