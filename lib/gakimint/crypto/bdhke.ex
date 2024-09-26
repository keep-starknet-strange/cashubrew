defmodule Gakimint.Crypto.BDHKE do
  @moduledoc """
  Cryptographic functions for the Gakimint mint, including BDHKE implementation.
  Check [NUT-00](https://cashubtc.github.io/nuts/00/) for more information.
  Protocol summary:
  - Alice (user) blinds the message and sends it to Bob (mint).
  - Bob signs the blinded message.
  - Alice unblinds the signature.
  - Carol (user) verifies the signature.
  """
  require Logger

  alias ExSecp256k1
  alias Gakimint.Crypto.Secp256k1Utils

  # Cashu parameters
  @domain_separator "Secp256k1_HashToCurve_Cashu_"

  # secp256k1 parameters
  @secp256k1_n 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141

  @doc """
  Generate a new keypair.
  Takes private key as input or generates a new one if not provided.
  """
  def generate_keypair(private_key \\ nil) do
    private_key =
      case private_key do
        nil -> :crypto.strong_rand_bytes(32)
        <<0, key::binary-size(32)>> -> key
        <<key::binary-size(32)>> -> key
        _ -> raise "Invalid private key format"
      end

    {:ok, public_key} = ExSecp256k1.create_public_key(private_key)
    {:ok, compressed_public_key} = ExSecp256k1.public_key_compress(public_key)
    {private_key, compressed_public_key}
  end

  @doc """
  Hash to curve function.
  """
  def hash_to_curve(message) do
    msg_hash = :crypto.hash(:sha256, @domain_separator <> message)
    hash_to_curve_loop(msg_hash, 0)
  end

  defp hash_to_curve_loop(msg_hash, counter) when counter < 65_536 do
    to_hash = msg_hash <> <<counter::little-32>>
    hash = :crypto.hash(:sha256, to_hash)

    case ExSecp256k1.create_public_key(hash) do
      {:ok, public_key} ->
        {:ok, compressed_key} = ExSecp256k1.public_key_compress(public_key)
        compressed_key

      _ ->
        hash_to_curve_loop(msg_hash, counter + 1)
    end
  end

  defp hash_to_curve_loop(_, _), do: raise("No valid point found")

  @doc """
  Alice's step 1: Blind the message.
  Alice is the sending user.
  Alice picks secret x and computes Y = hash_to_curve(x).
  Alice sends to Bob: B_ = Y + rG with r being a random blinding factor (blinding).
  This operation is called blinding.
  """
  def step1_alice(secret_msg, blinding_factor \\ nil) do
    y = hash_to_curve(secret_msg)
    r = blinding_factor || generate_keypair() |> elem(0)
    {:ok, r_pub} = ExSecp256k1.create_public_key(r)
    {:ok, r_pub_compressed} = ExSecp256k1.public_key_compress(r_pub)
    # B_ = Y + rG
    {:ok, b_prime} = Secp256k1Utils.point_add(y, r_pub_compressed)
    {b_prime, r}
  end

  @doc """
  Bob's step 2: Sign the blinded message.
  Bob is the mint.
  This operation is called signing.
  """
  def step2_bob(b_prime, a) do
    with {:ok, c_prime} <- Secp256k1Utils.point_mul(b_prime, a),
         {e, s} <- step2_bob_dleq(b_prime, a) do
      {c_prime, e, s}
    else
      error ->
        error
    end
  end

  @doc """
  Alice's step 3: Unblind the signature.
  Alice can calculate the unblinded key as C_ - rK = kY + krG - krG = kY = C.
  This operation is called unblinding.
  """
  def step3_alice(c_prime, r, a_pub) do
    with {:ok, r_a_pub} <- Secp256k1Utils.point_mul(a_pub, r),
         {:ok, c} <- Secp256k1Utils.point_sub(c_prime, r_a_pub) do
      c
    else
      error -> error
    end
  end

  @doc """
  Verify the signature.
  Carol is the receiving user.
  This operation is called verification.
  """
  def verify(a, c, secret_msg) do
    y = hash_to_curve(secret_msg)

    with {:ok, a_y} <- Secp256k1Utils.point_mul(y, a),
         true <- Secp256k1Utils.point_equal?(c, a_y) do
      true
    else
      _ -> false
    end
  end

  @doc """
  Generate DLEQ proof
  """
  def step2_bob_dleq(b_prime, a, p \\ nil) do
    p = p || :crypto.strong_rand_bytes(32)
    {:ok, r1} = ExSecp256k1.create_public_key(p)
    {:ok, r1_compressed} = ExSecp256k1.public_key_compress(r1)
    {:ok, r2} = Secp256k1Utils.point_mul(b_prime, p)
    {:ok, a_pub} = ExSecp256k1.create_public_key(a)
    {:ok, a_pub_compressed} = ExSecp256k1.public_key_compress(a_pub)
    {:ok, c_prime} = Secp256k1Utils.point_mul(b_prime, a)

    e = hash_e(r1_compressed, r2, a_pub_compressed, c_prime)
    e_scalar = :binary.decode_unsigned(e)
    a_times_e = Secp256k1Utils.mod_mul(:binary.decode_unsigned(a), e_scalar, @secp256k1_n)
    s = Secp256k1Utils.mod_add(:binary.decode_unsigned(p), a_times_e, @secp256k1_n)
    s_bin = :binary.encode_unsigned(s) |> Secp256k1Utils.pad_left(32)
    {e, s_bin}
  end

  @doc """
  Alice verifies DLEQ proof
  """
  def alice_verify_dleq(b_prime, c_prime, e, s, a_pub) do
    with {:ok, s_g} <- ExSecp256k1.create_public_key(s),
         {:ok, s_g_compressed} <- ExSecp256k1.public_key_compress(s_g),
         {:ok, e_a} <- Secp256k1Utils.point_mul(a_pub, e),
         {:ok, r1} <- Secp256k1Utils.point_sub(s_g_compressed, e_a),
         {:ok, s_b_prime} <- Secp256k1Utils.point_mul(b_prime, s),
         {:ok, e_c_prime} <- Secp256k1Utils.point_mul(c_prime, e),
         {:ok, r2} <- Secp256k1Utils.point_sub(s_b_prime, e_c_prime),
         computed_e <- hash_e(r1, r2, a_pub, c_prime),
         true <- computed_e == e do
      true
    else
      _ -> false
    end
  end

  @doc """
  Carol verifies DLEQ proof
  """
  def carol_verify_dleq(secret_msg, r, c, e, s, a_pub) do
    y = hash_to_curve(secret_msg)

    with {:ok, r_pub} <- ExSecp256k1.create_public_key(r),
         {:ok, r_pub_compressed} <- ExSecp256k1.public_key_compress(r_pub),
         {:ok, r_a_pub} <- Secp256k1Utils.point_mul(a_pub, r),
         {:ok, c_prime} <- Secp256k1Utils.point_add(c, r_a_pub),
         {:ok, b_prime} <- Secp256k1Utils.point_add(y, r_pub_compressed),
         true <- alice_verify_dleq(b_prime, c_prime, e, s, a_pub) do
      true
    else
      _ -> false
    end
  end

  @doc """
  Hash function for DLEQ
  """
  def hash_e(r1, r2, a, c_prime) do
    keys = [r1, r2, a, c_prime]

    data =
      Enum.map_join(keys, "", fn key ->
        {:ok, uncompressed} = ExSecp256k1.public_key_decompress(key)
        uncompressed
      end)

    :crypto.hash(:sha256, data)
  end
end
