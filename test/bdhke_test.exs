defmodule BDHKETest do
  use ExUnit.Case
  alias Gakimint.Crypto

  test "end-to-end BDHKE test" do
    IO.puts("\nStarting end-to-end test for Blind Diffie-Hellman Key Exchange (BDHKE)")

    # INIT: Setting up Alice's keys
    IO.puts("\n***********************************************************")
    IO.puts("INIT: Setting up Alice's keys")
    {a, a_pub} = Crypto.generate_keypair(<<1::256>>)
    IO.puts("Alice's private key (a): #{Base.encode16(a, case: :lower)}")
    IO.puts("Alice's public key (A): #{Base.encode16(a_pub, case: :lower)}")

    assert Base.encode16(a_pub, case: :lower) ==
             "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"

    IO.puts("***********************************************************\n")

    # PREPARE: Preparing secret message and blinding factor
    IO.puts("\n***********************************************************")
    IO.puts("PREPARE: Preparing secret message and blinding factor")
    secret_msg = "test_message"
    {r, r_pub} = Crypto.generate_keypair(<<1::256>>)
    IO.puts("Secret message: #{secret_msg}")
    IO.puts("r private key: #{Base.encode16(r, case: :lower)}")
    IO.puts("Blinding factor (r): #{Base.encode16(r_pub, case: :lower)}")
    IO.puts("***********************************************************\n")

    # STEP 1: Alice blinds the message
    IO.puts("\n***********************************************************")
    IO.puts("STEP 1: Alice blinds the message")
    {b_prime, _} = Crypto.step1_alice(secret_msg, r)
    IO.puts("Blinded message (B_): #{Base.encode16(b_prime, case: :lower)}")
    {x, y} = Crypto.pubkey_to_xy(b_prime)
    IO.puts("S1_Blinded_message_x: #{:binary.decode_unsigned(x)}")
    IO.puts("S1_Blinded_message_y: #{:binary.decode_unsigned(y)}")
    IO.puts("***********************************************************\n")

    # STEP 2: Bob signs the blinded message
    IO.puts("\n***********************************************************")
    IO.puts("STEP 2: Bob signs the blinded message")
    {c_prime, e, s} = Crypto.step2_bob(b_prime, a)
    IO.puts("Blinded signature (C_): #{Base.encode16(c_prime, case: :lower)}")
    IO.puts("DLEQ proof - e: #{Base.encode16(e, case: :lower)}")
    IO.puts("DLEQ proof - s: #{Base.encode16(s, case: :lower)}")
    IO.puts("***********************************************************\n")

    # ALICE VERIFY: Alice verifies the DLEQ proof
    IO.puts("\n***********************************************************")
    IO.puts("ALICE VERIFY: Alice verifies the DLEQ proof")
    alice_verification = Crypto.alice_verify_dleq(b_prime, c_prime, e, s, a_pub)
    assert alice_verification, "Alice's DLEQ verification failed"
    IO.puts("Alice successfully verified the DLEQ proof")
    IO.puts("***********************************************************\n")

    # STEP 3: Alice unblinds the signature
    IO.puts("\n***********************************************************")
    IO.puts("STEP 3: Alice unblinds the signature")
    c = Crypto.step3_alice(c_prime, r, a_pub)
    IO.puts("Unblinded signature (C): #{Base.encode16(c, case: :lower)}")
    IO.puts("***********************************************************\n")

    # CAROL VERIFY: Carol verifies the unblinded signature
    IO.puts("\n***********************************************************")
    IO.puts("CAROL VERIFY: Carol verifies the unblinded signature")
    carol_verification = Crypto.carol_verify_dleq(secret_msg, r, c, e, s, a_pub)
    assert carol_verification, "Carol's DLEQ verification failed"
    IO.puts("Carol successfully verified the unblinded signature")
    IO.puts("***********************************************************\n")

    IO.puts("End-to-end test completed successfully")
  end
end
