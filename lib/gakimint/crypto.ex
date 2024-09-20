defmodule Gakimint.Crypto do
  @moduledoc """
  Cryptographic functions for the Gakimint mint, including BDHKE implementation.
  """
  require Logger

  alias ExSecp256k1

  # Cashu parameters
  @domain_separator "Secp256k1_HashToCurve_Cashu_"

  # secp256k1 parameters
  @secp256k1_p 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F
  @secp256k1_n 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
  @secp256k1_a 0

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
  Alice's step 1: Blind the message
  """
  def step1_alice(secret_msg, blinding_factor \\ nil) do
    y = hash_to_curve(secret_msg)
    r = blinding_factor || generate_keypair() |> elem(0)
    {:ok, r_pub} = ExSecp256k1.create_public_key(r)
    {:ok, r_pub_compressed} = ExSecp256k1.public_key_compress(r_pub)
    {:ok, b_prime} = point_add(y, r_pub_compressed)
    {b_prime, r}
  end

  @doc """
  Bob's step 2: Sign the blinded message
  """
  def step2_bob(b_prime, a) do
    with {:ok, c_prime} <- point_mul(b_prime, a),
         {e, s} <- step2_bob_dleq(b_prime, a) do
      {c_prime, e, s}
    else
      error ->
        error
    end
  end

  @doc """
  Alice's step 3: Unblind the signature
  """
  def step3_alice(c_prime, r, a_pub) do
    with {:ok, r_a_pub} <- point_mul(a_pub, r),
         {:ok, c} <- point_sub(c_prime, r_a_pub) do
      c
    else
      error -> error
    end
  end

  @doc """
  Verify the signature
  """
  def verify(a, c, secret_msg) do
    y = hash_to_curve(secret_msg)

    with {:ok, a_y} <- point_mul(y, a),
         true <- point_equal?(c, a_y) do
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
    {:ok, r2} = point_mul(b_prime, p)
    {:ok, a_pub} = ExSecp256k1.create_public_key(a)
    {:ok, a_pub_compressed} = ExSecp256k1.public_key_compress(a_pub)
    {:ok, c_prime} = point_mul(b_prime, a)

    e = hash_e(r1_compressed, r2, a_pub_compressed, c_prime)
    e_scalar = :binary.decode_unsigned(e)
    a_times_e = mod_mul(:binary.decode_unsigned(a), e_scalar, @secp256k1_n)
    s = mod_add(:binary.decode_unsigned(p), a_times_e, @secp256k1_n)
    s_bin = :binary.encode_unsigned(s) |> pad_left(32)
    {e, s_bin}
  end

  @doc """
  Alice verifies DLEQ proof
  """
  def alice_verify_dleq(b_prime, c_prime, e, s, a_pub) do
    with {:ok, s_g} <- ExSecp256k1.create_public_key(s),
         {:ok, s_g_compressed} <- ExSecp256k1.public_key_compress(s_g),
         {:ok, e_a} <- point_mul(a_pub, e),
         {:ok, r1} <- point_sub(s_g_compressed, e_a),
         {:ok, s_b_prime} <- point_mul(b_prime, s),
         {:ok, e_c_prime} <- point_mul(c_prime, e),
         {:ok, r2} <- point_sub(s_b_prime, e_c_prime),
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
         {:ok, r_a_pub} <- point_mul(a_pub, r),
         {:ok, c_prime} <- point_add(c, r_a_pub),
         {:ok, b_prime} <- point_add(y, r_pub_compressed),
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

  @doc """
  Convert public key to x and y coordinates
  """
  def pubkey_to_xy(key) do
    {:ok, uncompressed_key} = ExSecp256k1.public_key_decompress(key)
    <<4::8, x::binary-size(32), y::binary-size(32)>> = uncompressed_key
    {x, y}
  end

  # Modular inverse
  defp inv_mod(a, p) do
    case extended_gcd(a, p) do
      {1, x, _} -> mod(x, p)
      {_gcd, _x, _y} -> raise "Inverse does not exist"
    end
  end

  defp extended_gcd(a, b) when a < 0 do
    extended_gcd(a + b, b)
  end

  defp extended_gcd(a, b) do
    if b == 0 do
      {a, 1, 0}
    else
      {gcd, x1, y1} = extended_gcd(b, rem(a, b))
      {gcd, y1, x1 - div(a, b) * y1}
    end
  end

  # Modular addition
  defp mod_add(a, b, n), do: mod(a + b, n)

  # Modular multiplication
  defp mod_mul(a, b, n), do: mod(a * b, n)

  defp secp256k1_point_add({x1, y1}, {x1, y1}) do
    # Point doubling
    numerator = 3 * x1 * x1 + @secp256k1_a
    denominator = 2 * y1
    s = mod(numerator * inv_mod(denominator, @secp256k1_p), @secp256k1_p)
    x3 = mod(s * s - 2 * x1, @secp256k1_p)
    y3 = mod(s * (x1 - x3) - y1, @secp256k1_p)
    {x3, y3}
  end

  defp secp256k1_point_add({x1, y1}, {x2, y2}) do
    # Point addition
    numerator = y2 - y1
    denominator = x2 - x1
    s = mod(numerator * inv_mod(denominator, @secp256k1_p), @secp256k1_p)
    x3 = mod(s * s - x1 - x2, @secp256k1_p)
    y3 = mod(s * (x1 - x3) - y1, @secp256k1_p)
    {x3, y3}
  end

  # Encoding point back to public key
  defp encode_point(x, y) do
    x_bin = pad_left(:binary.encode_unsigned(x), 32)
    y_bin = pad_left(:binary.encode_unsigned(y), 32)
    <<4::8, x_bin::binary-size(32), y_bin::binary-size(32)>>
  end

  # Padding function
  defp pad_left(binary, size) do
    padding_size = size - byte_size(binary)

    if padding_size > 0 do
      :binary.copy(<<0>>, padding_size) <> binary
    else
      binary
    end
  end

  # Negate point
  defp negate_point(point) do
    case ExSecp256k1.public_key_decompress(point) do
      {:ok, point_decomp} ->
        <<4::8, x_bin::binary-size(32), y_bin::binary-size(32)>> = point_decomp

        _x = :binary.decode_unsigned(x_bin)
        y = :binary.decode_unsigned(y_bin)
        y_neg = @secp256k1_p - y

        y_neg_bin = pad_left(:binary.encode_unsigned(y_neg), 32)
        result = <<4::8, x_bin::binary-size(32), y_neg_bin::binary-size(32)>>
        {:ok, compressed} = ExSecp256k1.public_key_compress(result)
        {:ok, compressed}

      error ->
        error
    end
  end

  # Point subtraction
  defp point_sub(p1, p2) do
    with {:ok, p2_neg} <- negate_point(p2),
         {:ok, result} <- point_add(p1, p2_neg) do
      {:ok, result}
    else
      error -> error
    end
  end

  # Point addition
  defp point_add(p1, p2) do
    with {:ok, p1_decomp} <- ExSecp256k1.public_key_decompress(p1),
         {:ok, p2_decomp} <- ExSecp256k1.public_key_decompress(p2) do
      <<4::8, x1_bin::binary-size(32), y1_bin::binary-size(32)>> = p1_decomp
      <<4::8, x2_bin::binary-size(32), y2_bin::binary-size(32)>> = p2_decomp

      x1 = :binary.decode_unsigned(x1_bin)
      y1 = :binary.decode_unsigned(y1_bin)
      x2 = :binary.decode_unsigned(x2_bin)
      y2 = :binary.decode_unsigned(y2_bin)

      point1 = {x1, y1}
      point2 = {x2, y2}

      result_point = secp256k1_point_add(point1, point2)

      case result_point do
        {x3, y3} ->
          result_pubkey = encode_point(x3, y3)
          {:ok, compressed} = ExSecp256k1.public_key_compress(result_pubkey)
          {:ok, compressed}
      end
    else
      error -> error
    end
  end

  def secp256k1_point_mul(k, x, y) do
    result = do_secp256k1_point_mul(k, x, y, nil)
    result
  end

  defp do_secp256k1_point_mul(k, x, y, acc) do
    case k do
      0 -> acc
      1 -> handle_k_one(acc, x, y)
      _ -> handle_k_greater_than_one(k, x, y, acc)
    end
  end

  defp handle_k_one(acc, x, y) do
    if acc == nil, do: {x, y}, else: secp256k1_point_add(acc, {x, y})
  end

  defp handle_k_greater_than_one(k, x, y, acc) do
    new_acc = update_accumulator(k, acc, x, y)
    {new_x, new_y} = secp256k1_point_add({x, y}, {x, y})
    do_secp256k1_point_mul(div(k, 2), new_x, new_y, new_acc)
  end

  defp update_accumulator(k, acc, x, y) do
    if rem(k, 2) == 1 do
      if acc == nil, do: {x, y}, else: secp256k1_point_add(acc, {x, y})
    else
      acc
    end
  end

  def point_mul(point, scalar_bin) do
    # Decompress the point to get x and y coordinates
    case ExSecp256k1.public_key_decompress(point) do
      {:ok, point_decomp} ->
        <<4::8, x_bin::binary-size(32), y_bin::binary-size(32)>> = point_decomp
        x = :binary.decode_unsigned(x_bin)
        y = :binary.decode_unsigned(y_bin)
        scalar = :binary.decode_unsigned(scalar_bin)

        # Perform scalar multiplication
        result_point = secp256k1_point_mul(scalar, x, y)

        case result_point do
          nil ->
            {:error, :point_at_infinity}

          {x_res, y_res} ->
            result_pubkey = encode_point(x_res, y_res)
            {:ok, compressed} = ExSecp256k1.public_key_compress(result_pubkey)
            {:ok, compressed}
        end

      error ->
        error
    end
  end

  # Point equality
  defp point_equal?(p1, p2) do
    {:ok, p1_decomp} = ExSecp256k1.public_key_decompress(p1)
    {:ok, p2_decomp} = ExSecp256k1.public_key_decompress(p2)
    p1_decomp == p2_decomp
  end

  defp mod(a, b) do
    rem = rem(a, b)

    if rem < 0 do
      rem + b
    else
      rem
    end
  end
end
