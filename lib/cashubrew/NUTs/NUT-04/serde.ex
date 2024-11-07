defmodule Cashubrew.Nuts.Nut04.Serde.PostMintQuoteBolt11Request do
  @moduledoc """
  The body of the post mint quote request
  """
  @enforce_keys [:amount, :unit]
  defstruct [:amount, :unit, :description]
end

defmodule Cashubrew.Nuts.Nut04.Serde.PostMintQuoteBolt11Response do
  @moduledoc """
  The body of the post mint quote response 
  """
  @enforce_keys [:quote, :request, :state, :expiry]
  defstruct [:quote, :request, :state, :expiry]
end

defmodule Cashubrew.Nuts.Nut04.Serde.PostMintBolt11Request do
  @moduledoc """
  The body of the post mint request
  """
  alias Cashubrew.Nuts.Nut00.BlindedMessage

  @enforce_keys [:quote, :outputs]
  defstruct [:quote, :outputs]

  def from_map(map) do
    %__MODULE__{
      quote: Map.fetch!(map, "quote"),
      outputs: BlindedMessage.from_list(Map.fetch!(map, "outputs"))
    }
  end
end

defmodule Cashubrew.Nuts.Nut04.Serde.PostMintBolt11Response do
  @moduledoc """
  The body of the post mint response
  """
  @enforce_keys [:signatures]
  @derive [Jason.Encoder]
  defstruct [:signatures]
end
