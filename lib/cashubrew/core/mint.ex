defmodule Cashubrew.Mint do
  @moduledoc """
  Mint operations for the Cashubrew mint.
  """

  require Logger
  alias Cashubrew.Nuts.Nut00.{BDHKE, BlindSignature}
  alias Cashubrew.Nuts.Nut02

  alias Cashubrew.Schema

  alias Cashubrew.Schema.{
    Key,
    MintConfiguration,
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

  def init do
    repo = Application.get_env(:cashubrew, :repo)
    seed = get_or_create_seed(repo)
    _keysets = load_or_create_keysets(repo, seed)
    {_mint_privkey, _mint_pubkey} = get_or_create_mint_key(repo, seed)
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
        keys = Nut02.Keysets.generate_keys(seed, keyset_generation_derivation_path())

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
    {:ok, {private_key, public_key}} = BDHKE.generate_keypair(private_key)
    {private_key, public_key}
  end

  def create_blinded_signatures(repo, blinded_messages) do
    signatures =
      Enum.map(blinded_messages, fn bm ->
        # Get key from database
        amount_key = get_key_for_amount(repo, bm.id, bm.amount)
        privkey = amount_key.private_key
        # Bob (mint) signs the blinded message
        b_prime = Base.decode16!(bm."B_", case: :lower)
        {:ok, {c_prime, _e, _s}} = BDHKE.step2_bob(b_prime, privkey)

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

  def get_pubkey(repo) do
    repo.get(Schema.MintConfiguration, mint_pubkey_key())
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

  def generate_promises(repo, keyset_id, verified_outputs) do
    Enum.reduce(verified_outputs, [], fn output, acc ->
      key = get_key_for_amount(repo, keyset_id, output.amount)
      {:ok, {c_prime, e, s}} = BDHKE.step2_bob(output."B_", key.private_key)

      [
        %Schema.Promises{
          b: output."B_",
          keyset_id: keyset_id,
          amount: output.amount,
          c: c_prime,
          e: e,
          s: s
        }
        | acc
      ]
    end)
  end
end
