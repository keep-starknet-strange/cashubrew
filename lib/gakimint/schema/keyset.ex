defmodule Gakimint.Schema.Keyset do
  use Ecto.Schema
  import Ecto.Changeset
  import Bitwise
  @primary_key {:id, :string, autogenerate: false}
  schema "keysets" do
    field(:active, :boolean, default: true)
    field(:unit, :string)

    timestamps()
  end

  def changeset(keyset, attrs) do
    keyset
    |> cast(attrs, [:id, :active, :unit])
    |> validate_required([:id, :unit])
  end

  def generate(unit \\ "sat") do
    keys = generate_keys()
    id = derive_keyset_id(keys)

    keyset = %__MODULE__{
      id: id,
      active: true,
      unit: unit
    }

    {:ok, keyset} = Gakimint.Repo.insert(keyset)

    # Insert keys into the database
    Enum.each(keys, fn key ->
      key = Map.put(key, :keyset_id, id)

      %Gakimint.Schema.Key{}
      |> Gakimint.Schema.Key.changeset(key)
      |> Gakimint.Repo.insert!()
    end)

    # Log the number of keys inserted
    IO.inspect(length(keys), label: "Number of keys inserted")

    keyset
  end

  def derive_keyset_id(keys) do
    keys
    |> Enum.sort_by(fn key ->
      case Integer.parse(key.amount) do
        {int, _} ->
          int

        :error ->
          "0x" <> hex = key.amount
          String.to_integer(hex, 16)
      end
    end)
    |> Enum.map(fn key -> Base.decode16!(key.public_key, case: :lower) end)
    |> Enum.reduce(<<>>, fn pubkey, acc -> acc <> pubkey end)
    |> (&:crypto.hash(:sha256, &1)).()
    |> Base.encode16(case: :lower)
    |> (&("00" <> binary_part(&1, 0, 14))).()
  end

  defp generate_keys do
    Enum.map(0..62, fn i ->
      amount = power_of_two(i)
      {private_key, public_key} = Gakimint.Crypto.generate_keypair()

      %{
        amount: amount,
        private_key: private_key,
        public_key: Base.encode16(public_key, case: :lower)
      }
    end)
  end

  defp power_of_two(i) do
    Integer.to_string(1 <<< i)
  end
end
