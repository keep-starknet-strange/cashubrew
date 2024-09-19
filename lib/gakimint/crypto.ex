defmodule Gakimint.Crypto do
  @moduledoc """
  Cryptographic functions for the Gakimint mint.
  """

  @domain_separator "Secp256k1_HashToCurve_Cashu_"

  @doc """
  Generate a new keypair.
  """
  def generate_keypair do
    private_key = :crypto.strong_rand_bytes(32)
    {:ok, public_key_point} = ExSecp256k1.create_public_key(private_key)
    public_key_compressed = compress_public_key(public_key_point)
    {private_key, public_key_compressed}
  end

  # Compress the public key point
  defp compress_public_key(<<4, x::binary-size(32), y::binary-size(32)>>) do
    prefix = if :binary.decode_unsigned(y) |> rem(2) == 0, do: <<2>>, else: <<3>>
    prefix <> x
  end

  @doc """
  Sign a message with a private key.
  """
  def sign(message, private_key) do
    ExSecp256k1.sign(message, private_key)
  end

  @doc """
  Verify a signature with a public key.
  """
  def verify(message, signature, public_key) do
    ExSecp256k1.verify(signature, message, public_key)
  end

  @doc """
  Hash to curve function.
  """
  def hash_to_curve(message) do
    msg_to_hash = :crypto.hash(:sha256, @domain_separator <> message)
    hash_to_curve_loop(msg_to_hash, 0)
  end

  defp hash_to_curve_loop(msg_to_hash, counter) when counter < 65536 do
    to_hash = msg_to_hash <> <<counter::little-32>>
    hash = :crypto.hash(:sha256, to_hash)

    case ExSecp256k1.create_public_key(hash) do
      {:ok, public_key} -> public_key
      _ -> hash_to_curve_loop(msg_to_hash, counter + 1)
    end
  end

  defp hash_to_curve_loop(_, _), do: raise("No valid point found")
end
