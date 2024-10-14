defmodule Cashubrew.Crypto.Secp256k1Utils do
  @moduledoc """
  Utility functions for secp256k1.
  """
  alias ExSecp256k1

  # secp256k1 parameters
  defp secp256k1_p do
    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F
  end

  defp secp256k1_a do
    0
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
  def inv_mod(a, p) do
    case extended_gcd(a, p) do
      {1, x, _} -> mod(x, p)
      {_gcd, _x, _y} -> raise "Inverse does not exist"
    end
  end

  def extended_gcd(a, b) when a < 0 do
    extended_gcd(a + b, b)
  end

  def extended_gcd(a, b) do
    if b == 0 do
      {a, 1, 0}
    else
      {gcd, x1, y1} = extended_gcd(b, rem(a, b))
      {gcd, y1, x1 - div(a, b) * y1}
    end
  end

  # Modular addition
  def mod_add(a, b, n), do: mod(a + b, n)

  # Modular multiplication
  def mod_mul(a, b, n), do: mod(a * b, n)

  def secp256k1_point_add({x1, y1}, {x1, y1}) do
    # Point doubling
    numerator = 3 * x1 * x1 + secp256k1_a()
    denominator = 2 * y1
    s = mod(numerator * inv_mod(denominator, secp256k1_p()), secp256k1_p())
    x3 = mod(s * s - 2 * x1, secp256k1_p())
    y3 = mod(s * (x1 - x3) - y1, secp256k1_p())
    {x3, y3}
  end

  def secp256k1_point_add({x1, y1}, {x2, y2}) do
    # Point addition
    numerator = y2 - y1
    denominator = x2 - x1
    s = mod(numerator * inv_mod(denominator, secp256k1_p()), secp256k1_p())
    x3 = mod(s * s - x1 - x2, secp256k1_p())
    y3 = mod(s * (x1 - x3) - y1, secp256k1_p())
    {x3, y3}
  end

  # Encoding point back to public key
  def encode_point(x, y) do
    x_bin = pad_left(:binary.encode_unsigned(x), 32)
    y_bin = pad_left(:binary.encode_unsigned(y), 32)
    <<4::8, x_bin::binary-size(32), y_bin::binary-size(32)>>
  end

  # Padding function
  def pad_left(binary, size) do
    padding_size = size - byte_size(binary)

    if padding_size > 0 do
      :binary.copy(<<0>>, padding_size) <> binary
    else
      binary
    end
  end

  # Negate point
  def negate_point(point) do
    case ExSecp256k1.public_key_decompress(point) do
      {:ok, point_decomp} ->
        <<4::8, x_bin::binary-size(32), y_bin::binary-size(32)>> = point_decomp

        _x = :binary.decode_unsigned(x_bin)
        y = :binary.decode_unsigned(y_bin)
        y_neg = secp256k1_p() - y

        y_neg_bin = pad_left(:binary.encode_unsigned(y_neg), 32)
        result = <<4::8, x_bin::binary-size(32), y_neg_bin::binary-size(32)>>
        {:ok, compressed} = ExSecp256k1.public_key_compress(result)
        {:ok, compressed}

      error ->
        error
    end
  end

  # Point subtraction
  def point_sub(p1, p2) do
    with {:ok, p2_neg} <- negate_point(p2),
         {:ok, result} <- point_add(p1, p2_neg) do
      {:ok, result}
    else
      error -> error
    end
  end

  # Point addition
  def point_add(p1, p2) do
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

  def do_secp256k1_point_mul(k, x, y, acc) do
    case k do
      0 -> acc
      1 -> handle_k_one(acc, x, y)
      _ -> handle_k_greater_than_one(k, x, y, acc)
    end
  end

  def handle_k_one(acc, x, y) do
    if acc == nil, do: {x, y}, else: secp256k1_point_add(acc, {x, y})
  end

  def handle_k_greater_than_one(k, x, y, acc) do
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
  def point_equal?(p1, p2) do
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
