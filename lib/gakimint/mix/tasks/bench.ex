defmodule Mix.Tasks.Bench do
  @moduledoc """
  Benchmark for the Gakimint mint.
  """
  use Mix.Task

  alias Gakimint.Crypto.BDHKE

  @shortdoc "Runs the BDHKE benchmark"

  def run(_args) do
    Mix.Task.run("app.start")

    # Setup before benchmark
    {a, a_pub} = BDHKE.generate_keypair(<<1::256>>)
    secret_msg = "test_message"
    {r, _r_pub} = BDHKE.generate_keypair(<<1::256>>)

    if Code.ensure_loaded?(Benchee) do
      # Run the BDHKE benchmark
      Benchee.run(
        %{
          "BDHKE End-to-End Flow" => fn ->
            run_bdhke_flow(a, a_pub, secret_msg, r)
          end
        },
        formatters: [
          Benchee.Formatters.HTML,
          Benchee.Formatters.Console
        ],
        time: 10,
        memory_time: 2
      )
    else
      IO.puts("Benchee is not available. Make sure you're running in the :dev environment.")
    end
  end

  def run_bdhke_flow(a, a_pub, secret_msg, r) do
    # STEP 1: Alice blinds the message
    {b_prime, _} = BDHKE.step1_alice(secret_msg, r)

    # STEP 2: Bob signs the blinded message
    {c_prime, _, _} = BDHKE.step2_bob(b_prime, a)

    # STEP 3: Alice unblinds the signature
    c = BDHKE.step3_alice(c_prime, r, a_pub)

    # CAROL VERIFY: Carol verifies the unblinded signature
    carol_verification = BDHKE.verify(a, c, secret_msg)

    if carol_verification do
      :ok
    else
      raise "Carol's DLEQ verification failed"
    end
  end
end
