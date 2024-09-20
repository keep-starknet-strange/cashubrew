defmodule Gakimint.Mint do
  use GenServer
  alias Gakimint.Repo
  alias Gakimint.Schema.{Keyset, Key, MintConfiguration}
  import Ecto.Query

  @keyset_generation_seed_key "keyset_generation_seed"
  @keyset_generation_derivation_path "m/0'/0'/0'"

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{keysets: []}, {:continue, :load_keysets}}
  end

  @impl true
  def handle_continue(:load_keysets, state) do
    seed = get_or_create_seed()
    keysets = load_or_create_keysets(seed)
    {:noreply, %{state | keysets: keysets}}
  end

  defp get_or_create_seed do
    case Repo.get_by(MintConfiguration, key: @keyset_generation_seed_key) do
      nil ->
        seed =
          System.get_env("KEYSET_GENERATION_SEED") ||
            :crypto.strong_rand_bytes(32) |> Base.encode16(case: :lower)

        %MintConfiguration{}
        |> MintConfiguration.changeset(%{key: @keyset_generation_seed_key, value: seed})
        |> Repo.insert!()

        seed

      config ->
        config.value
    end
  end

  defp load_or_create_keysets(seed) do
    case Repo.all(Keyset) do
      [] ->
        keyset = Keyset.generate("sat", seed, @keyset_generation_derivation_path)
        [keyset]

      existing ->
        existing
    end
  end

  @impl true
  def handle_call(:get_keysets, _from, state) do
    {:reply, state.keysets, state}
  end

  # Public API

  def get_keysets do
    GenServer.call(__MODULE__, :get_keysets)
  end

  def get_keys_for_keyset(keyset_id) do
    Repo.all(
      from(k in Key,
        where: k.keyset_id == ^keyset_id,
        order_by: [asc: k.amount]
      )
    )
  end

  def get_pubkey do
    [keyset | _] = get_keysets()
    keys = get_keys_for_keyset(keyset.id)
    keys_map = Enum.into(keys, %{}, fn key -> {key.amount, key.public_key} end)
    keys_map["1"]
  end

  def get_active_keysets do
    Repo.all(from(k in Keyset, where: k.active == true))
  end
end
