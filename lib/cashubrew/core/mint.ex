defmodule Cashubrew.Mint do
  @moduledoc """
  Mint operations for the Cashubrew mint.
  """

  use GenServer
  alias Cashubrew.Nuts.Nut00.{BDHKE, BlindSignature}
  alias Cashubrew.Nuts.Nut02

  alias Cashubrew.Schema

  alias Cashubrew.Schema.{
    Key,
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
    {:ok, %{mint_pubkey: nil}, {:continue, :load_keysets_and_mint_key}}
  end

  @impl true
  @spec handle_continue(:load_keysets_and_mint_key, %{
          :mint_pubkey => any(),
          optional(any()) => any()
        }) :: {:noreply, %{:mint_pubkey => binary(), optional(any()) => any()}}
  def handle_continue(:load_keysets_and_mint_key, state) do
    repo = Application.get_env(:cashubrew, :repo)
    seed = get_or_create_seed(repo)
    _keysets = load_or_create_keysets(repo, seed)
    {_, mint_pubkey} = get_or_create_mint_key(repo, seed)
    {:noreply, %{state | mint_pubkey: mint_pubkey}}
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

  # Public API

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
    repo.all(from(k in Schema.Keyset, where: k.active == true))
  end

  def get_all_keysets(repo) do
    repo.all(Schema.Keyset)
  end

  def get_keyset(repo, keyset_id) do
    repo.get(Schema.Keyset, keyset_id)
  end

  def mint_tokens(quote, blinded_messages) do
    GenServer.call(__MODULE__, {:mint_tokens, quote, blinded_messages})
  end

  def check_proofs_are_used?(repo, proofs) do
    # Todo: do it at the database level for better perf
    used_proofs = repo.all(UsedProof)
    Enum.any?(used_proofs, fn p -> p in proofs end)
  end

  def register_used_proofs(repo, proofs) do
    used_proofs =
      Enum.each(proofs, fn p ->
        %UsedProof{keyset_id: p.id, amount: p.amount, secret: p.secret, c: p."C"}
      end)

    repo.insert_all(UsedProof, used_proofs)
  end
end
