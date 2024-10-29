defmodule Cashubrew.Nuts.Nut05.Serde.PostMeltQuoteBolt11Request do
  @moduledoc """
  The body of the post melt quote request
  """
  @enforce_keys [:request, :unit]
  defstruct [:request, :unit]
end

defmodule Cashubrew.Nuts.Nut05.Serde.PostMeltBolt11Request do
  @moduledoc """
  The body of the post melt request
  """
  alias Cashubrew.Nuts.Nut00.Proof

  @enforce_keys [:quote, :inputs]
  defstruct [:quote, :inputs]

  def from_map(map) do
    %__MODULE__{
      quote: Map.fetch!(map, "quote"),
      inputs: Proof.from_list(Map.fetch!(map, "inputs"))
    }
  end
end

defmodule Cashubrew.Nuts.Nut05.Serde.PostMeltQuoteBolt11Response do
  @moduledoc """
  The body of the post melt quote response 
  """
  @enforce_keys [:quote, :amount, :fee_reserve, :state, :expiry]
  defstruct [:quote, :amount, :fee_reserve, :state, :expiry, :payment_preimage]
end
