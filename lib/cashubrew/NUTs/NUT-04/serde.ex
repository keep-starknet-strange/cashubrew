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
  @enforce_keys [:quote, :outputs]
  defstruct [:quote, :outputs]
end

defmodule Cashubrew.Nuts.Nut04.Serde.PostMintBolt11Response do
  @moduledoc """
  The body of the post mint response
  """
  @enforce_keys [:signatures]
  defstruct [:signatures]
end
