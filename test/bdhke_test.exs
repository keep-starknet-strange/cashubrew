defmodule BDHKETest do
  @moduledoc """
  Test for the Blind Diffie-Hellman Key Exchange (BDHKE) implementation.
  """
  use ExUnit.Case
  require Logger
  alias Cashubrew.Crypto.Secp256k1Utils
  alias Cashubrew.Nuts.Nut00.BDHKE

  test "end-to-end BDHKE test" do
    Logger.info("\nStarting end-to-end test for Blind Diffie-Hellman Key Exchange (BDHKE)")

    # INIT: Setting up Alice's keys
    Logger.info("\n***********************************************************")
    Logger.info("INIT: Setting up Alice's keys")
    {:ok, {a, a_pub}} = BDHKE.generate_keypair(<<1::256>>)
    Logger.info("Alice's private key (a): #{Base.encode16(a, case: :lower)}")
    Logger.info("Alice's public key (A): #{Base.encode16(a_pub, case: :lower)}")

    assert Base.encode16(a_pub, case: :lower) ==
             "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"

    Logger.info("***********************************************************\n")

    # PREPARE: Preparing secret message and blinding factor
    Logger.info("\n***********************************************************")
    Logger.info("PREPARE: Preparing secret message and blinding factor")
    secret_msg = "test_message"
    {:ok, {r, r_pub}} = BDHKE.generate_keypair(<<1::256>>)
    Logger.info("Secret message: #{secret_msg}")
    Logger.info("r private key: #{Base.encode16(r, case: :lower)}")
    Logger.info("Blinding factor (r): #{Base.encode16(r_pub, case: :lower)}")
    Logger.info("***********************************************************\n")

    # STEP 1: Alice blinds the message
    Logger.info("\n***********************************************************")
    Logger.info("STEP 1: Alice blinds the message")
    {:ok, {b_prime, _}} = BDHKE.step1_alice(secret_msg, r)
    Logger.info("Blinded message (B_): #{Base.encode16(b_prime, case: :lower)}")
    {x, y} = Secp256k1Utils.pubkey_to_xy(b_prime)
    Logger.info("S1_Blinded_message_x: #{:binary.decode_unsigned(x)}")
    Logger.info("S1_Blinded_message_y: #{:binary.decode_unsigned(y)}")
    Logger.info("***********************************************************\n")

    # STEP 2: Bob signs the blinded message
    Logger.info("\n***********************************************************")
    Logger.info("STEP 2: Bob signs the blinded message")
    {:ok, {c_prime, e, s}} = BDHKE.step2_bob(b_prime, a)
    Logger.info("Blinded signature (C_): #{inspect(c_prime)}")
    Logger.info("DLEQ proof - e: #{inspect(e)}")
    Logger.info("DLEQ proof - s: #{inspect(s)}")
    Logger.info("***********************************************************\n")

    # ALICE VERIFY: Alice verifies the DLEQ proof
    Logger.info("\n***********************************************************")
    Logger.info("ALICE VERIFY: Alice verifies the DLEQ proof")
    alice_verification = BDHKE.alice_verify_dleq?(b_prime, c_prime, e, s, a_pub)
    assert alice_verification, "Alice's DLEQ verification failed"
    Logger.info("Alice successfully verified the DLEQ proof")
    Logger.info("***********************************************************\n")

    # STEP 3: Alice unblinds the signature
    Logger.info("\n***********************************************************")
    Logger.info("STEP 3: Alice unblinds the signature")
    {:ok, c} = BDHKE.step3_alice(c_prime, r, a_pub)
    Logger.info("Unblinded signature (C): #{Base.encode16(c, case: :lower)}")
    Logger.info("***********************************************************\n")

    # CAROL VERIFY: Carol verifies the unblinded signature
    Logger.info("\n***********************************************************")
    Logger.info("CAROL VERIFY: Carol verifies the unblinded signature")
    carol_verification = BDHKE.carol_verify_dleq?(secret_msg, r, c, e, s, a_pub)
    assert carol_verification, "Carol's DLEQ verification failed"
    Logger.info("Carol successfully verified the unblinded signature")
    Logger.info("***********************************************************\n")

    Logger.info("End-to-end test completed successfully")
  end
end
