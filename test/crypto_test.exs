defmodule CryptoTest do
  use ExUnit.Case

  alias Cashubrew.Nuts.Nut00.BDHKE

  test "step 1" do
    secret_msg = "test_message"
    private_key = "0000000000000000000000000000000000000000000000000000000000000001"

    {:ok, blinding_factor} = private_key |> Base.decode16(case: :lower)
    {:ok, {b_, r}} = BDHKE.step1_alice(secret_msg, blinding_factor)

    assert b_ |> Base.encode16(case: :lower) ==
             "025cc16fe33b953e2ace39653efb3e7a7049711ae1d8a2f7a9108753f1cdea742b"

    assert r |> Base.encode16(case: :lower) == private_key
  end

  test "step 2" do
    secret_msg = "test_message"
    private_key = "0000000000000000000000000000000000000000000000000000000000000001"

    {:ok, blinding_factor} = private_key |> Base.decode16(case: :lower)
    {:ok, {b_, r}} = BDHKE.step1_alice(secret_msg, blinding_factor)

    assert b_ |> Base.encode16(case: :lower) ==
             "025cc16fe33b953e2ace39653efb3e7a7049711ae1d8a2f7a9108753f1cdea742b"

    assert r |> Base.encode16(case: :lower) == private_key

    {:ok, a} = private_key |> Base.decode16(case: :lower)
    {:ok, {c_, _e, _s}} = BDHKE.step2_bob(b_, a)

    assert c_ |> Base.encode16(case: :lower) ==
             "025cc16fe33b953e2ace39653efb3e7a7049711ae1d8a2f7a9108753f1cdea742b"
  end

  test "step 3" do
    # step 1
    secret_msg = "test_message"
    private_key = "0000000000000000000000000000000000000000000000000000000000000001"

    {:ok, blinding_factor} = private_key |> Base.decode16(case: :lower)
    {:ok, {b_, r}} = BDHKE.step1_alice(secret_msg, blinding_factor)

    assert b_ |> Base.encode16(case: :lower) ==
             "025cc16fe33b953e2ace39653efb3e7a7049711ae1d8a2f7a9108753f1cdea742b"

    assert r |> Base.encode16(case: :lower) == private_key

    # step 2
    {:ok, a} = private_key |> Base.decode16(case: :lower)
    {:ok, {c_, _e, _s}} = BDHKE.step2_bob(b_, a)

    assert c_ |> Base.encode16(case: :lower) ==
             "025cc16fe33b953e2ace39653efb3e7a7049711ae1d8a2f7a9108753f1cdea742b"

    # step 3
    {:ok, hash} =
      "0000000000000000000000000000000000000000000000000000000000000001"
      |> Base.decode16(case: :lower)

    {:ok, big_A} = BDHKE.load_public_key(<<2>> <> hash)
    {:ok, c} = BDHKE.step3_alice(c_, r, big_A)

    assert c |> Base.encode16(case: :lower) ==
             "0271bf0d702dbad86cbe0af3ab2bfba70a0338f22728e412d88a830ed0580b9de4"
  end

  test "hash_e" do
    {:ok, c_decoded} =
      "02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2"
      |> Base.decode16(case: :lower)

    {:ok, c_} = BDHKE.load_public_key(c_decoded)

    {:ok, hash} =
      "0000000000000000000000000000000000000000000000000000000000000001"
      |> Base.decode16(case: :lower)

    {:ok, k} = BDHKE.load_public_key(<<2>> <> hash)

    {:ok, hash} =
      "0000000000000000000000000000000000000000000000000000000000000001"
      |> Base.decode16(case: :lower)

    {:ok, r1} = BDHKE.load_public_key(<<2>> <> hash)

    {:ok, hash} =
      "0000000000000000000000000000000000000000000000000000000000000001"
      |> Base.decode16(case: :lower)

    {:ok, r2} = BDHKE.load_public_key(<<2>> <> hash)

    e = BDHKE.hash_e(r1, r2, k, c_)

    assert e |> Base.encode16(case: :lower) ==
             "a4dc034b74338c28c6bc3ea49731f2a24440fc7c4affc08b31a93fc9fbe6401e"
  end

  test "step2 Bob DLEQ" do
    # step 1
    secret_msg = "test_message"
    private_key = "0000000000000000000000000000000000000000000000000000000000000001"

    {:ok, blinding_factor} = private_key |> Base.decode16(case: :lower)
    {:ok, {b_, _}} = BDHKE.step1_alice(secret_msg, blinding_factor)

    {:ok, a} = private_key |> Base.decode16(case: :lower)

    # 32 bytes
    {:ok, p_bytes} =
      "0000000000000000000000000000000000000000000000000000000000000001"
      |> Base.decode16(case: :lower)

    {:ok, {e, s}} = BDHKE.step2_bob_dleq(b_, a, p_bytes)

    assert e |> Base.encode16(case: :lower) ==
             "a608ae30a54c6d878c706240ee35d4289b68cfe99454bbfa6578b503bce2dbe1"

    assert s |> Base.encode16(case: :lower) ==
             "a608ae30a54c6d878c706240ee35d4289b68cfe99454bbfa6578b503bce2dbe2"

    # differs from e only in least significant byte because `a = 0x1`

    # change `a`
    {:ok, a} =
      "0000000000000000000000000000000000000000000000000000000000001111"
      |> Base.decode16(case: :lower)

    {:ok, {e, s}} = BDHKE.step2_bob_dleq(b_, a, p_bytes)

    assert e |> Base.encode16(case: :lower) ==
             "076cbdda4f368053c33056c438df014d1875eb3c8b28120bece74b6d0e6381bb"

    assert s |> Base.encode16(case: :lower) ==
             "b6d41ac1e12415862bf8cace95e5355e9262eab8a11d201dadd3b6e41584ea6e"
  end

  test "Alice verify DLEQ" do
    # e from test step2_bob_dleq for a=0x1
    {:ok, e} =
      "9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73d9"
      |> Base.decode16(case: :lower)

    # s from test step2_bob_dleq for a=0x1
    {:ok, s} =
      "9818e061ee51d5c8edc3342369a554998ff7b4381c8652d724cdf46429be73da"
      |> Base.decode16(case: :lower)

    {:ok, a} =
      "0000000000000000000000000000000000000000000000000000000000000001"
      |> Base.decode16(case: :lower)

    {:ok, a_public_key} = BDHKE.generate_public_key(a)

    # B_ is the same as we did in test step 1
    {:ok, b_} =
      "02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2"
      |> Base.decode16(case: :lower)

    # C_ is the same as we did in test step 2
    {:ok, c_} =
      "02a9acc1e48c25eeeb9289b5031cc57da9fe72f3fe2861d264bdc074209b107ba2"
      |> Base.decode16(case: :lower)

    assert BDHKE.alice_verify_dleq(b_, c_, e, s, a_public_key)
  end

  test "Alice direct verify DLEQ" do
    secret_msg = "test_message"
    private_key = "0000000000000000000000000000000000000000000000000000000000000001"
    # ----- test again with B_ and C_ as per step1 and step2
    {:ok, a} = private_key |> Base.decode16(case: :lower)
    {:ok, a_public_key} = BDHKE.generate_public_key(a)

    {:ok, blinding_factor} = private_key |> Base.decode16(case: :lower)
    {:ok, {b_, _}} = BDHKE.step1_alice(secret_msg, blinding_factor)

    {:ok, {c_, e, s}} = BDHKE.step2_bob(b_, a)
    assert BDHKE.alice_verify_dleq(b_, c_, e, s, a_public_key)
  end

  test "Carol verify from Bob" do
    secret_msg = "test_message"
    private_key = "0000000000000000000000000000000000000000000000000000000000000001"

    {:ok, a} = private_key |> Base.decode16(case: :lower)
    {:ok, a_public_key} = BDHKE.generate_public_key(a)

    assert a_public_key |> Base.encode16(case: :lower) ==
             "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"

    {:ok, r} =
      "0000000000000000000000000000000000000000000000000000000000000001"
      |> Base.decode16(case: :lower)

    {:ok, {b_, _}} = BDHKE.step1_alice(secret_msg, r)
    {:ok, {c_, e, s}} = BDHKE.step2_bob(b_, a)
    assert BDHKE.alice_verify_dleq(b_, c_, e, s, a_public_key)

    {:ok, c} = BDHKE.step3_alice(c_, r, a_public_key)

    # carol does not know B_ and C_, but she receives C and r from Alice
    assert BDHKE.carol_verify_dleq(secret_msg = secret_msg, r, c, e, s, a_public_key)
  end
end
