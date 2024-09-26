defmodule Cashubrew.Wallet do
  @moduledoc """
  Handles wallet-related operations for the Cashubrew CLI.
  """

  alias Cashubrew.Crypto.BDHKE

  @data_dir "./_build/.cashubrew/data"
  @wallet_file "wallet.json"

  defmodule WalletStruct do
    @moduledoc """
    Struct representing a wallet with private and public keys.
    """
    @derive Jason.Encoder
    defstruct [:private_key, :public_key]
  end

  def load_or_create_wallet do
    case load_wallet() do
      nil -> generate_wallet()
      wallet -> validate_wallet(wallet)
    end
  end

  defp validate_wallet(wallet) do
    case struct(WalletStruct, wallet) do
      %WalletStruct{private_key: nil} -> generate_wallet()
      %WalletStruct{public_key: nil} -> generate_wallet()
      valid_wallet -> valid_wallet
    end
  end

  def generate_wallet do
    {private_key, public_key} = BDHKE.generate_keypair()

    wallet = %WalletStruct{
      private_key: Base.encode16(private_key, case: :lower),
      public_key: Base.encode16(public_key, case: :lower)
    }

    store_wallet(wallet)
    wallet
  end

  defp load_wallet do
    case File.read("#{@data_dir}/#{@wallet_file}") do
      {:ok, content} -> Jason.decode!(content)
      {:error, _} -> nil
    end
  end

  defp store_wallet(wallet) do
    File.mkdir_p!(@data_dir)
    File.write!("#{@data_dir}/#{@wallet_file}", Jason.encode!(wallet))
  end
end
