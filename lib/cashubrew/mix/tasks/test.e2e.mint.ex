defmodule Mix.Tasks.Test.E2e.Mint do
  @moduledoc """
  Test for the BMint
  """
  use Mix.Task

  @shortdoc "Runs the Mint end-to-end test"
  def run(_) do
    Mix.Task.run("app.start", ["--no-start"])
    ExUnit.start()
    Code.require_file("test/integration_mint.exs")
    ExUnit.run()
  end
end
