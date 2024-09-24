defmodule Gakimint.MockRepo do
  @moduledoc """
  Mock repository for testing without a database.
  """

  use GenServer
  alias Ecto.Schema.Loader

  @behaviour Ecto.Repo

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  # Implement required Ecto.Repo callbacks

  def config do
    [
      pool_size: 1,
      telemetry_prefix: [:gakimint, :mock_repo]
    ]
  end

  def __adapter__ do
    Ecto.Adapters.SQL
  end

  def checkout(_, _) do
    {:ok, self()}
  end

  def checked_out? do
    false
  end

  def default_options(_) do
    []
  end

  def get_dynamic_repo do
    __MODULE__
  end

  def put_dynamic_repo(_) do
    :ok
  end

  def stop(_) do
    :ok
  end

  def load(schema_or_types, data) do
    case schema_or_types do
      schema when is_atom(schema) ->
        Loader.unsafe_load(schema, data, &load_type/2)

      types when is_map(types) ->
        Loader.unsafe_load(%{}, types, data, &load_type/2)
    end
  end

  defp load_type(type, value) do
    case Ecto.Type.adapter_load(Ecto.Adapters.SQL, type, value) do
      {:ok, value} -> value
      :error -> raise ArgumentError, "cannot load `#{inspect(value)}` as type #{inspect(type)}"
    end
  end

  # Existing CRUD operations

  def all(queryable) do
    GenServer.call(__MODULE__, {:all, queryable})
  end

  def get(queryable, id, opts \\ []) do
    GenServer.call(__MODULE__, {:get, queryable, id, opts})
  end

  def get_by(queryable, clauses, opts \\ []) do
    GenServer.call(__MODULE__, {:get_by, queryable, clauses, opts})
  end

  def insert(struct, opts \\ []) do
    GenServer.call(__MODULE__, {:insert, struct, opts})
  end

  def insert!(struct, opts \\ []) do
    case insert(struct, opts) do
      {:ok, struct} ->
        struct

      {:error, changeset} ->
        raise Ecto.InvalidChangesetError, action: :insert, changeset: changeset
    end
  end

  def update(struct, opts \\ []) do
    GenServer.call(__MODULE__, {:update, struct, opts})
  end

  def delete(struct, opts \\ []) do
    GenServer.call(__MODULE__, {:delete, struct, opts})
  end

  # GenServer callbacks

  def handle_call({:all, queryable}, _from, state) do
    result = Map.get(state, queryable, [])
    {:reply, result, state}
  end

  def handle_call({:get, queryable, id, _opts}, _from, state) do
    result = get_by_id(state, queryable, id)
    {:reply, result, state}
  end

  def handle_call({:get_by, queryable, clauses, _opts}, _from, state) do
    result = get_by_clauses(state, queryable, clauses)
    {:reply, result, state}
  end

  def handle_call({:insert, %Ecto.Changeset{} = changeset, _opts}, _from, state) do
    insert_changeset(changeset, state)
  end

  def handle_call({:insert, struct, opts}, from, state) do
    changeset = Ecto.Changeset.change(struct)
    handle_call({:insert, changeset, opts}, from, state)
  end

  def handle_call({:update, struct, _opts}, _from, state) do
    new_state = update_struct(state, struct)
    {:reply, {:ok, struct}, new_state}
  end

  def handle_call({:delete, struct, _opts}, _from, state) do
    new_state = delete_struct(state, struct)
    {:reply, {:ok, struct}, new_state}
  end

  # Private functions

  defp get_by_id(state, queryable, id) do
    state
    |> Map.get(queryable, [])
    |> Enum.find(fn item -> item.id == id end)
  end

  defp get_by_clauses(state, queryable, clauses) do
    state
    |> Map.get(queryable, [])
    |> Enum.find(fn item ->
      Enum.all?(clauses, fn {key, value} -> Map.get(item, key) == value end)
    end)
  end

  defp insert_changeset(changeset, state) do
    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, struct} -> insert_struct(struct, state)
      {:error, changeset} -> {:reply, {:error, changeset}, state}
    end
  end

  defp insert_struct(struct, state) do
    id = System.unique_integer([:positive])
    inserted_at = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    updated_at = inserted_at

    new_struct =
      struct
      |> Map.from_struct()
      |> Map.merge(%{id: id, inserted_at: inserted_at, updated_at: updated_at})
      |> then(&struct(struct.__struct__, &1))

    new_state = Map.update(state, struct.__struct__, [new_struct], &[new_struct | &1])
    {:reply, {:ok, new_struct}, new_state}
  end

  defp update_struct(state, struct) do
    Map.update!(state, struct.__struct__, &update_list(&1, struct))
  end

  defp update_list(list, struct) do
    Enum.map(list, &update_item(&1, struct))
  end

  defp update_item(item, struct) do
    if item.id == struct.id, do: struct, else: item
  end

  defp delete_struct(state, struct) do
    Map.update!(state, struct.__struct__, fn list ->
      Enum.reject(list, &(&1.id == struct.id))
    end)
  end
end
