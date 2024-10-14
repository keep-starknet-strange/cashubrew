defmodule Cashubrew.Mint do
  @moduledoc """
  Mint operations for the Cashubrew mint.
  """

  use GenServer
  alias Cashubrew.Lightning.LightningNetworkService
  alias Cashubrew.Lightning.MockLightningNetworkService
  alias Cashubrew.Nuts.Nut00.{BDHKE, BlindSignature}
  alias Cashubrew.Nuts.Nut02
  alias Cashubrew.Query.MeltTokens

  alias Cashubrew.Schema

  alias Cashubrew.Schema.{
    Key,
    MeltQuote,
    MeltTokens,
    MintConfiguration,
    MintQuote,
    UsedProof
  }

  import Ecto.Query

  defp keyset_generation_seed_key do
    "keyset_generation_seed"
  end

  defp keyset_generation_derivation_path do
    "m/0'/0'/0'"
  end

  defp mint_pubkey_key do
    "mint_pubkey"
  end

  defp mint_privkey_key do
    "mint_privkey"
  end

  defp default_input_fee_ppk do
    0
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{keysets: [], mint_pubkey: nil}, {:continue, :load_keysets_and_mint_key}}
  end

  @impl true
  @spec handle_continue(:load_keysets_and_mint_key, %{
          :keysets => any(),
          :mint_pubkey => any(),
          optional(any()) => any()
        }) :: {:noreply, %{:keysets => any(), :mint_pubkey => binary(), optional(any()) => any()}}
  def handle_continue(:load_keysets_and_mint_key, state) do
    repo = Application.get_env(:cashubrew, :repo)
    seed = get_or_create_seed(repo)
    keysets = load_or_create_keysets(repo, seed)
    {_, mint_pubkey} = get_or_create_mint_key(repo, seed)
    {:noreply, %{state | keysets: keysets, mint_pubkey: mint_pubkey}}
  end

  defp get_or_create_seed(repo) do
    case repo.get_by(MintConfiguration, key: keyset_generation_seed_key()) do
      nil ->
        seed =
          System.get_env("KEYSET_GENERATION_SEED") ||
            :crypto.strong_rand_bytes(32) |> Base.encode16(case: :lower)

        case %MintConfiguration{}
             |> MintConfiguration.changeset(%{key: keyset_generation_seed_key(), value: seed})
             |> repo.insert() do
          {:ok, config} ->
            config.value

          {:error, changeset} ->
            raise "Failed to insert MintConfiguration: #{inspect(changeset.errors)}"
        end

      config ->
        config.value
    end
  end

  defp load_or_create_keysets(repo, seed) do
    case repo.all(Schema.Keyset) do
      [] ->
        keys = Nut02.Keyset.generate_keys(seed, keyset_generation_derivation_path())

        keyset =
          Schema.Keyset.register_keyset(
            keys,
            "sat",
            default_input_fee_ppk()
          )

        [keyset]

      existing ->
        existing
    end
  end

  defp get_or_create_mint_key(repo, seed) do
    case {repo.get_by(MintConfiguration, key: mint_pubkey_key()),
          repo.get_by(MintConfiguration, key: mint_privkey_key())} do
      {nil, nil} ->
        {privkey, pubkey} = derive_mint_key(seed)

        %MintConfiguration{}
        |> MintConfiguration.changeset(%{
          key: mint_pubkey_key(),
          value: Base.encode16(pubkey, case: :lower)
        })
        |> repo.insert!()

        %MintConfiguration{}
        |> MintConfiguration.changeset(%{
          key: mint_privkey_key(),
          value: Base.encode16(privkey, case: :lower)
        })
        |> repo.insert!()

        {privkey, pubkey}

      {pubkey_config, privkey_config} ->
        pubkey = Base.decode16!(pubkey_config.value, case: :lower)
        privkey = Base.decode16!(privkey_config.value, case: :lower)
        {privkey, pubkey}
    end
  end

  defp derive_mint_key(seed) do
    private_key = :crypto.hash(:sha256, seed)
    {private_key, public_key} = BDHKE.generate_keypair(private_key)
    {private_key, public_key}
  end

  @impl true
  def handle_call(:get_keysets, _from, state) do
    {:reply, state.keysets, state}
  end

  @impl true
  def handle_call(:get_mint_pubkey, _from, state) do
    {:reply, state.mint_pubkey, state}
  end

  def handle_call({:create_mint_quote, amount, description}, _from, state) do
    repo = Application.get_env(:cashubrew, :repo)

    case LightningNetworkService.create_invoice(amount, description) do
      {:ok, payment_request, _payment_hash} ->
        # 1 hour expiry
        expiry = :os.system_time(:second) + 3600

        attrs = %{
          amount: amount,
          payment_request: payment_request,
          expiry: expiry,
          description: description
          # payment_hash: _payment_hash,
        }

        case repo.insert(MintQuote.changeset(%MintQuote{}, attrs)) do
          {:ok, quote} ->
            {:reply, {:ok, quote}, state}

          {:error, changeset} ->
            {:reply, {:error, changeset}, state}
        end

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  def handle_call({:get_mint_quote, quote_id}, _from, state) do
    repo = Application.get_env(:cashubrew, :repo)
    quote = repo.get(MintQuote, quote_id)

    if quote do
      case MockLightningNetworkService.check_payment(quote.payment_request) do
        {:ok, :paid} ->
          updated_quote = Ecto.Changeset.change(quote, state: "PAID")
          {:ok, updated_quote} = repo.update(updated_quote)
          {:reply, {:ok, updated_quote}, state}

        _ ->
          {:reply, {:ok, quote}, state}
      end
    else
      {:reply, {:error, :not_found}, state}
    end
  end

  def handle_call({:mint_tokens, quote_id, blinded_messages}, _from, state) do
    repo = Application.get_env(:cashubrew, :repo)
    # Get quote from database
    quote = repo.get(MintQuote, quote_id)

    # Return error if quote does not exist
    if quote do
      result =
        Ecto.Multi.new()
        |> Ecto.Multi.run(:verify_quote, fn _, _ ->
          # Implement actual Lightning payment verification
          # For now, we mock the payment as if it's been received
          {:ok, quote}
        end)
        |> Ecto.Multi.update(:update_quote, fn %{verify_quote: quote} ->
          Ecto.Changeset.change(quote, state: "ISSUED")
        end)
        |> Ecto.Multi.run(:create_blinded_signatures, fn _, _ ->
          create_blinded_signatures(repo, blinded_messages)
        end)
        |> repo.transaction()

      case result do
        {:ok, %{create_blinded_signatures: signatures}} ->
          {:reply, {:ok, signatures}, state}

        {:error, _, reason, _} ->
          {:reply, {:error, reason}, state}
      end
    else
      {:reply, {:error, :not_found}, state}
    end
  end

  def create_blinded_signatures(blinded_messages) do
    repo = Application.get_env(:cashubrew, :repo)
    create_blinded_signatures(repo, blinded_messages)
  end

  defp create_blinded_signatures(repo, blinded_messages) do
    signatures =
      Enum.map(blinded_messages, fn bm ->
        # Get key from database
        amount_key = get_key_for_amount(repo, bm.id, bm.amount)
        privkey = amount_key.private_key
        # Bob (mint) signs the blinded message
        b_prime = Base.decode16!(bm."B_", case: :lower)
        {c_prime, _e, _s} = BDHKE.step2_bob(b_prime, privkey)

        %BlindSignature{
          amount: bm.amount,
          id: bm.id,
          C_: Base.encode16(c_prime, case: :lower)
        }
      end)

    {:ok, signatures}
  end

  def handle_call({:create_melt_quote, request, unit}, _from, state) do
    repo = Application.get_env(:cashubrew, :repo)
    # # Check LN invoice and info
    {:ok, invoice} = Bitcoinex.LightningNetwork.decode_invoice(request)
    # To call the function and print the hash:
    {:ok, request} = RandomHash.generate_hash()
    # Used amount
    # If :amount exists, returns its value; otherwise returns 1000
    amount = Map.get(invoice, :amount_msat, 1000)

    fee_reserve = 0
    # Create and Saved melt quote
    expiry = :os.system_time(:second) + 3600

    attrs = %{
      # quote_id
      request: request,
      unit: unit,
      amount: amount,
      fee_reserve: fee_reserve,
      expiry: expiry,
      request_lookup_id: request
    }

    case repo.insert(MeltQuote.changeset(%MeltQuote{}, attrs)) do
      {:ok, melt_quote} ->
        {:reply, {:ok, melt_quote}, state}

      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  def handle_call({:create_melt_tokens, quote_id, _inputs}, _from, state) do
    repo = Application.get_env(:cashubrew, :repo)

    # TODO
    # Verify quote_id

    {:ok, melt_find} = Cashubrew.Query.MeltTokens.get_melt_by_quote_id!(quote_id)
    IO.puts("melt_find: #{melt_find}")

    # Check if quote is already paid or not

    # Check total amount

    # Check proofs

    # Verify proof spent

    fee_reserve = 0
    # Create and Saved melt quote

    attrs = %{
      # quote_id
      request: quote_id,
      unit: quote_id,
      amount: 0,
      fee_reserve: 0,
      expiry: 0,
      request_lookup_id: quote_id
    }

    expiry = :os.system_time(:second) + 3600

    case repo.insert(MeltTokens.changeset(%MeltTokens{}, attrs)) do
      {:ok, melt_quote} ->
        {:reply, {:ok, melt_quote}, state}

      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  # Public API

  def get_keysets do
    GenServer.call(__MODULE__, :get_keysets)
  end

  def get_keys_for_keyset(repo, keyset_id) do
    repo.all(
      from(k in Key,
        where: k.keyset_id == ^keyset_id,
        order_by: [asc: k.amount]
      )
    )
  end

  def get_key_for_amount(repo, keyset_id, amount) do
    repo.get_by(Key, keyset_id: keyset_id, amount: amount)
  end

  def get_pubkey do
    GenServer.call(__MODULE__, :get_mint_pubkey)
  end

  def get_active_keysets(repo) do
    repo.all(from(k in Keyset, where: k.active == true))
  end

  def get_all_keysets(repo) do
    repo.all(Keyset)
  end

  def get_keyset(repo, keyset_id) do
    repo.get(Keyset, keyset_id)
  end

  def create_mint_quote(amount, description) do
    GenServer.call(__MODULE__, {:create_mint_quote, amount, description})
  end

  def get_mint_quote(quote_id) do
    GenServer.call(__MODULE__, {:get_mint_quote, quote_id})
  end

  def mint_tokens(quote, blinded_messages) do
    GenServer.call(__MODULE__, {:mint_tokens, quote, blinded_messages})
  end

  def create_melt_quote(request, unit) do
    GenServer.call(__MODULE__, {:create_melt_quote, request, unit})
  end

  def create_melt_tokens(quote_id, inputs) do
    GenServer.call(__MODULE__, {:create_melt_tokens, quote_id, inputs})
  end

  def check_proofs_are_used?(proofs) do
    repo = Application.get_env(:cashubrew, :repo)

    # Todo: do it at the database level for better perf
    used_proofs = repo.all(UsedProof)
    Enum.any?(used_proofs, fn p -> p in proofs end)
  end

  def register_used_proofs(proofs) do
    repo = Application.get_env(:cashubrew, :repo)

    used_proofs =
      Enum.each(proofs, fn p ->
        %UsedProof{keyset_id: p.id, amount: p.amount, secret: p.secret, c: p."C"}
      end)

    repo.insert_all(UsedProof, used_proofs)
  end
end
