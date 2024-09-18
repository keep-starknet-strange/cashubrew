defmodule Gakimint.Mint do
  use GenServer
  alias Gakimint.Schema.Keyset
  alias Gakimint.Repo

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec init(any()) :: {:ok, %{}, {:continue, :load_keyset}}
  def init(_) do
    {:ok, %{}, {:continue, :load_keyset}}
  end

  def handle_continue(:load_keyset, state) do
    keyset =
      case Repo.get_by(Keyset, active: true) do
        nil -> create_new_keyset()
        existing -> existing
      end

    {:noreply, Map.put(state, :keyset, keyset)}
  end

  defp create_new_keyset do
    {private_keys, public_keys} = generate_keys()

    # Id of the keyset is computed from the public keys
    # For now we will take a random value
    id = Gakimint.Keyset.derive_keyset_id(public_keys)

    {:ok, keyset} =
      %Keyset{id: id}
      |> Keyset.changeset(%{
        private_keys: private_keys,
        public_keys: public_keys,
        active: true
      })
      |> Repo.insert()

    keyset
  end

  defp generate_keys do
    Enum.reduce(0..31, {%{}, %{}}, fn i, {priv, pub} ->
      amount = trunc(:math.pow(2, i))
      {private_key, public_key} = Gakimint.Crypto.generate_keypair()

      {
        Map.put(priv, amount, Base.encode16(private_key, case: :lower)),
        Map.put(pub, amount, Base.encode16(public_key, case: :lower))
      }
    end)
  end

  def handle_call(:get_keyset, _from, state) do
    {:reply, state.keyset, state}
  end

  # Public API

  def get_keyset do
    GenServer.call(__MODULE__, :get_keyset)
  end
end
