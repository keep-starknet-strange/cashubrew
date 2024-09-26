defmodule Cashubrew.Types.BigInteger do
  @moduledoc """
  Custom Ecto type for big integers.
  """
  use Ecto.Type

  def type, do: :string

  def cast(value) when is_integer(value), do: {:ok, Integer.to_string(value)}
  def cast(value) when is_binary(value), do: {:ok, value}
  def cast(_), do: :error

  def load(value), do: {:ok, String.to_integer(value)}

  def dump(value) when is_integer(value), do: {:ok, Integer.to_string(value)}
  def dump(value) when is_binary(value), do: {:ok, value}
  def dump(_), do: :error
end
