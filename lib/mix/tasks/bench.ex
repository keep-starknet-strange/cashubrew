defmodule Mix.Tasks.Bench do
  use Mix.Task

  @shortdoc "Runs the BDHKE benchmark"

  def run(_args) do
    Mix.Task.run("app.start")

    # Setup before benchmark
    {a, a_pub} = Gakimint.Crypto.generate_keypair(<<1::256>>)
    secret_msg = "test_message"
    {r, _r_pub} = Gakimint.Crypto.generate_keypair(<<1::256>>)

    Benchee.run(
      %{
        "BDHKE End-to-End Flow" => fn ->
          Gakimint.BDHKEModule.run_bdhke_flow(a, a_pub, secret_msg, r)
        end
      },
      time: 10,
      memory_time: 2
    )
  end
end
