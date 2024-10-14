defmodule Cashubrew.Nuts.Nut00.Error do
  @moduledoc """
  An error to be return by the API endpoints
  """

  @derive Jason.Encoder
  defstruct [:detail, :code]

  @type t :: %__MODULE__{
          code: non_neg_integer(),
          detail: String.t()
        }

  @doc """
  Creates a new error struct.
  """
  @spec new_error(non_neg_integer(), String.t()) :: t()
  def new_error(code, detail) do
    %__MODULE__{code: code, detail: detail}
  end
end
