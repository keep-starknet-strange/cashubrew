defmodule Mix.Tasks.Test.Unit.Cashu do
  @moduledoc """
  Test for the Cashu token serialization and deserialization.
  """
  use Mix.Task

  @shortdoc "Runs the Cashu unit tests"
  def run(_) do
    Mix.Task.run("app.start", ["--no-start"])
    ExUnit.start()
    Code.require_file("test/cashu_token_serde_test.exs")
    ExUnit.run()
  end
end
