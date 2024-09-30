defmodule RandomHash do
  @moduledoc """
  Random Hash module
  """
  # Import the necessary modules
  require Logger
  alias :crypto, as: Crypto

  def generate_hash do
    # Step 1: Generate a random 32-byte binary
    random_bytes = :crypto.strong_rand_bytes(32)

    # Step 2: Hash the random bytes using SHA-256
    hash = Crypto.hash(:sha256, random_bytes)

    # Step 3: Encode the hash in hexadecimal
    hash_hex = Base.encode16(hash, case: :lower)

    # Return the result
    {:ok, hash_hex}
  rescue
    error -> {:error, error}
  end
end
