defmodule Gakimint.BDHKEModule do
  require Logger
  alias Gakimint.Crypto

  def run_bdhke_flow(a, a_pub, secret_msg, r) do
    # STEP 1: Alice blinds the message
    {b_prime, _} = Crypto.step1_alice(secret_msg, r)

    # STEP 2: Bob signs the blinded message
    {c_prime, e, s} = Crypto.step2_bob(b_prime, a)

    # STEP 3: Alice unblinds the signature
    c = Crypto.step3_alice(c_prime, r, a_pub)

    # CAROL VERIFY: Carol verifies the unblinded signature
    carol_verification = Crypto.carol_verify_dleq(secret_msg, r, c, e, s, a_pub)

    if carol_verification do
      :ok
    else
      raise "Carol's DLEQ verification failed"
    end
  end
end
