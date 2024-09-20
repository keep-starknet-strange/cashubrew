defmodule Mix.Tasks.Test.E2e.Bdhke do
  @moduledoc """
  Test for the Blind Diffie-Hellman Key Exchange (BDHKE) end-to-end flow.
  """
  use Mix.Task

  @shortdoc "Runs the BDHKE end-to-end test"
  def run(_) do
    Mix.Task.run("app.start", ["--no-start"])
    ExUnit.start()
    Code.require_file("test/bdhke_test.exs")
    ExUnit.run()
  end
end
