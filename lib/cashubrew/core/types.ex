defmodule Cashubrew.Cashu.BlindedMessage do
  @moduledoc """
  Represents a BlindedMessage in the Cashu protocol.
  """

  @derive Jason.Encoder
  defstruct [:amount, :id, :B_]

  @type t :: %__MODULE__{
          amount: non_neg_integer(),
          id: String.t(),
          B_: String.t()
        }

  @doc """
  Creates a new BlindedMessage struct.
  """
  @spec new_blinded_message(non_neg_integer(), String.t(), String.t()) :: t()
  def new_blinded_message(amount, id, b_) do
    %__MODULE__{amount: amount, id: id, B_: b_}
  end
end

defmodule Cashubrew.Cashu.BlindSignature do
  @moduledoc """
  Represents a BlindSignature in the Cashu protocol.
  """

  @derive Jason.Encoder
  defstruct [:amount, :id, :C_]

  @type t :: %__MODULE__{
          amount: non_neg_integer(),
          id: String.t(),
          C_: String.t()
        }

  @doc """
  Creates a new BlindSignature struct.
  """
  @spec new(non_neg_integer(), String.t(), String.t()) :: t()
  def new(amount, id, c_) do
    %__MODULE__{amount: amount, id: id, C_: c_}
  end
end

defmodule Cashubrew.Cashu.Proof do
  @moduledoc """
  Represents a Proof in the Cashu protocol.
  """

  @derive Jason.Encoder
  defstruct [:amount, :id, :secret, :C]

  @type t :: %__MODULE__{
          amount: non_neg_integer(),
          id: String.t(),
          secret: String.t(),
          C: String.t()
        }

  @doc """
  Creates a new Proof struct.
  """
  @spec new(non_neg_integer(), String.t(), String.t(), String.t()) :: t()
  def new(amount, id, secret, c) do
    %__MODULE__{amount: amount, id: id, secret: secret, C: c}
  end
end
