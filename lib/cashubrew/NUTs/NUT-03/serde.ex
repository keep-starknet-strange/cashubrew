defmodule Cashubrew.Nuts.Nut03.Serde.PostSwapRequest do
  @moduledoc """
  The body of the post swap rest request
  """
  alias Cashubrew.Nuts.Nut00.{BlindedMessage, Proof}
  @enforce_keys [:inputs, :outputs]
  defstruct [:inputs, :outputs]

  def from_map(map) do
    %__MODULE__{
      inputs: Proof.from_list(Map.fetch(map, "inputs")),
      outputs: BlindedMessage.from_list(Map.fetch(map, "outputs"))
    }
  end
end

defmodule Cashubrew.Nuts.Nut03.Serde.PostSwapResponse do
  @moduledoc """
  The body of the post swap rest response
  """
  @enforce_keys [:signatures]
  defstruct [:signatures]
end
