defmodule Gakimint.Mint do
  use GenServer
  alias Gakimint.Repo
  alias Gakimint.Schema.{Keyset, Key}
  import Ecto.Query

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{keysets: []}, {:continue, :load_keysets}}
  end

  @impl true
  def handle_continue(:load_keysets, state) do
    keysets = load_or_create_keysets()
    {:noreply, %{state | keysets: keysets}}
  end

  defp load_or_create_keysets do
    case Repo.all(Keyset) do
      [] ->
        keyset = Keyset.generate()
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
end
