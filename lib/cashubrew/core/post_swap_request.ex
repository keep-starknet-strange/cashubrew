defmodule Cashubrew.PostSwapRequest do
  @moduledoc """
  {
    "inputs": <Array[Proof]>,
    "outputs": <Array[BlindedMessage]>,
  }
  """

  defstruct [:inputs, :outputs]

  def new(inputs, outputs) do
    %__MODULE__{
      inputs: inputs,
      outputs: outputs
    }
  end
end
