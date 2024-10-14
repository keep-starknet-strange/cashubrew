defmodule Cashubrew.Nuts.Nut03.Serde.PostSwapRequest do
  @moduledoc """
  The body of the post swap rest request
  """
  @enforce_keys [:inputs, :outputs]
  defstruct [:inputs, :outputs]
end

defmodule Cashubrew.Nuts.Nut03.Serde.PostSwapResponse do
  @moduledoc """
  The body of the post swap rest response
  """
  @enforce_keys [:signatures]
  defstruct [:signatures]
end
