defmodule Cashubrew.Nuts.Nut05.Serde.PostMeltQuoteBolt11Request do
  @moduledoc """
  The body of the post melt quote request
  """
  @enforce_keys [:request, :unit]
  @derive [Jason.Encoder]
  defstruct [:request, :unit]
end

defmodule Cashubrew.Nuts.Nut05.Serde.PostMeltBolt11Request do
  @moduledoc """
  The body of the post melt request
  """
  alias Cashubrew.Nuts.Nut00.Proof

  @enforce_keys [:quote, :inputs]
  @derive [Jason.Encoder]
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
  @derive [Jason.Encoder]
  defstruct [:quote, :amount, :fee_reserve, :state, :expiry, :payment_preimage]

  def from_melt_quote(melt_quote, state, payment_preimage) do
    %__MODULE__{
      quote: Ecto.UUID.cast!(melt_quote.id),
      amount: melt_quote.amount,
      fee_reserve: melt_quote.fee_reserve,
      expiry: melt_quote.expiry,
      state: state,
      payment_preimage: payment_preimage
    }
  end
end
