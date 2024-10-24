defmodule Cashubrew.Mint.VerificationTest do
  use ExUnit.Case, async: true
  alias Cashubrew.Mint.Verification.Amount
  alias Cashubrew.Mint.Verification.Inputs
  alias Cashubrew.Mint.Verification.InputsAndOutputs
  alias Cashubrew.Mint.Verification.Outputs
  alias Cashubrew.Nuts.Nut00.BDHKE
  alias Cashubrew.Nuts.Nut02

  defmodule MockRepo do
    alias Cashubrew.Schema

    def get(schema, "99") when schema == Schema.Keyset,
      do: %Schema.Keyset{id: "99", active: true, unit: "bit", input_fee_ppk: 1}

    def get(schema, "98") when schema == Schema.Keyset, do: nil

    def get(schema, "97") when schema == Schema.Keyset,
      do: %Schema.Keyset{id: "97", active: false, unit: "sat", input_fee_ppk: 1}

    def get(schema, id) when schema == Schema.Keyset,
      do: %Schema.Keyset{id: id, active: true, unit: "sat", input_fee_ppk: 1}

    def get_by(schema, opts) when schema == Schema.Key,
      do: %Schema.Key{
        keyset_id: opts[:keyset_id],
        amount: opts[:amount],
        private_key: "pk",
        public_key: "pubk"
      }

    def exists?(schema, opts) when schema == Schema.Promises, do: opts[:b] == "B99"
  end

  describe "Amount.verify!/1" do
    test "raises error for negative amount" do
      assert_raise RuntimeError, "BlindMessageAmountShouldBePositive", fn ->
        Amount.verify!(-1)
      end
    end

    test "raises error for amount exceeding max order" do
      assert_raise RuntimeError, "BlindMessageAmountNotExceed2MaxOrder", fn ->
        Amount.verify!(Integer.pow(2, Nut02.Keysets.max_order() + 1))
      end
    end

    test "passes for valid amount" do
      assert Amount.verify!(100) == nil
    end
  end

  describe "Inputs.verify!/2" do
    setup do
      inputs = [
        %{id: "1", amount: 100, secret: "secret1", C: "C1"},
        %{id: "2", amount: 200, secret: "secret2", C: "C2"}
      ]

      {:ok, inputs: inputs}
    end

    test "raises error for empty list", %{inputs: _inputs} do
      assert_raise RuntimeError, "EmptyListOfProof", fn ->
        Inputs.verify!(MockRepo, [])
      end
    end

    test "raises error for unknown keyset", %{inputs: _inputs} do
      assert_raise RuntimeError, "UnkownKeyset", fn ->
        Inputs.verify!(MockRepo, [%{id: "98", amount: 100, secret: "secret1", C: "C1"}])
      end
    end

    test "raises error when no secret", %{inputs: _inputs} do
      assert_raise RuntimeError, "NoSecretInProof", fn ->
        Inputs.verify!(MockRepo, [
          %{id: "2", amount: 200, secret: "", C: "C2"}
        ])
      end

      assert_raise RuntimeError, "NoSecretInProof", fn ->
        Inputs.verify!(MockRepo, [
          %{id: "2", amount: 200, secret: nil, C: "C2"}
        ])
      end
    end

    test "raises error for secret too long", %{inputs: _inputs} do
      assert_raise RuntimeError, "SecretTooLong", fn ->
        Inputs.verify!(MockRepo, [
          %{id: "2", amount: 200, secret: String.duplicate("F", 513), C: "C2"}
        ])
      end
    end

    test "raises error for duplicate secrets", %{inputs: inputs} do
      :meck.new(BDHKE, [:passthrough])
      :meck.expect(BDHKE, :verify?, fn _, _, _ -> true end)

      duplicate_inputs = [%{id: "3", amount: 300, secret: "secret1", C: "C3"} | inputs]

      assert_raise RuntimeError, "DuplicateProofInList", fn ->
        Inputs.verify!(MockRepo, duplicate_inputs)
      end

      :meck.unload(BDHKE)
    end

    test "raises error for different units", %{inputs: inputs} do
      :meck.new(BDHKE, [:passthrough])
      :meck.expect(BDHKE, :verify?, fn _, _, _ -> true end)

      assert_raise RuntimeError, "DifferentUnits", fn ->
        # The mock repo will return a keyset with different unit for id == 99
        Inputs.verify!(MockRepo, [%{id: "99", amount: 300, secret: "secret3", C: "C3"} | inputs])
      end

      :meck.unload(BDHKE)
    end

    test "raises error for invalid proof", %{inputs: inputs} do
      assert_raise ArgumentError, fn ->
        Inputs.verify!(MockRepo, inputs)
      end
    end

    test "passes for valid inputs", %{inputs: inputs} do
      :meck.new(BDHKE, [:passthrough])
      :meck.expect(BDHKE, :verify?, fn _, _, _ -> true end)

      {total_fee, total_amount, unit} = Inputs.verify!(MockRepo, inputs)
      assert total_fee == 2
      assert total_amount == 300
      assert unit == "sat"

      :meck.unload(BDHKE)
    end
  end

  describe "Outputs.verify!/2" do
    setup do
      outputs = [
        %{id: "1", amount: 100, B_: "B1"},
        %{id: "1", amount: 200, B_: "B2"}
      ]

      {:ok, outputs: outputs}
    end

    test "raises error for empty list", %{outputs: _outputs} do
      assert_raise RuntimeError, "Empty", fn ->
        Outputs.verify!(MockRepo, [])
      end
    end

    test "raises error for unknown keyset", %{outputs: _inputs} do
      assert_raise RuntimeError, "UnkownKeyset", fn ->
        Outputs.verify!(MockRepo, [%{id: "98", amount: 100, B_: "B1"}])
      end
    end

    test "raises error for inactive keyset", %{outputs: _inputs} do
      assert_raise RuntimeError, "InactiveKeyset", fn ->
        Outputs.verify!(MockRepo, [%{id: "97", amount: 100, B_: "B1"}])
      end
    end

    test "raises error for different keyset ids", %{outputs: outputs} do
      invalid_outputs = [%{id: "2", amount: 300, B_: "B3"} | outputs]

      assert_raise RuntimeError, "DifferentKeysetIds", fn ->
        Outputs.verify!(MockRepo, invalid_outputs)
      end
    end

    test "raises error for duplicate blinded message", %{outputs: outputs} do
      invalid_outputs = [%{id: "3", amount: 300, B_: "B1"} | outputs]

      assert_raise RuntimeError, "DifferentKeysetIds", fn ->
        Outputs.verify!(MockRepo, invalid_outputs)
      end
    end

    test "raises error for already emited message", %{outputs: outputs} do
      # the mocked repo will return exist == true for "B99"
      invalid_outputs = [%{id: "3", amount: 300, B_: "B99"} | outputs]

      assert_raise RuntimeError, "AlreadyEmitted", fn ->
        Outputs.verify!(MockRepo, invalid_outputs)
      end
    end

    test "passes for valid outputs", %{outputs: outputs} do
      {keyset, total_amount} = Outputs.verify!(MockRepo, outputs)
      assert total_amount == 300
      assert keyset.id == "1"
    end
  end

  describe "InputsAndOutputs.verify!/3" do
    setup do
      inputs = [
        %{id: "1", amount: 100, secret: "secret1", C: "C1"},
        %{id: "1", amount: 200, secret: "secret2", C: "C2"}
      ]

      outputs = [
        %{id: "1", amount: 290, B_: "B1"}
      ]

      {:ok, inputs: inputs, outputs: outputs}
    end

    test "raises error for different input and output units", %{inputs: inputs, outputs: outputs} do
      :meck.new(Inputs, [:passthrough])
      :meck.expect(Inputs, :verify!, fn _, _ -> {10, 300, "sat"} end)

      :meck.new(Outputs, [:passthrough])
      :meck.expect(Outputs, :verify!, fn _, _ -> {%{unit: "bit"}, 290} end)

      assert_raise RuntimeError, "DifferentInputAndOutputUnit", fn ->
        InputsAndOutputs.verify!(MockRepo, inputs, outputs)
      end

      :meck.unload(Inputs)
      :meck.unload(Outputs)
    end

    test "raises error for invalid amount and fee", %{inputs: inputs, outputs: outputs} do
      :meck.new(Inputs, [:passthrough])
      :meck.expect(Inputs, :verify!, fn _, _ -> {10, 300, "sat"} end)

      :meck.new(Outputs, [:passthrough])
      :meck.expect(Outputs, :verify!, fn _, _ -> {%{unit: "sat"}, 280} end)

      assert_raise RuntimeError, "InvalidAmountAndFee", fn ->
        InputsAndOutputs.verify!(MockRepo, inputs, outputs)
      end

      :meck.unload(Inputs)
      :meck.unload(Outputs)
    end

    test "passes for valid inputs and outputs", %{inputs: inputs, outputs: outputs} do
      :meck.new(Inputs, [:passthrough])
      :meck.expect(Inputs, :verify!, fn _, _ -> {10, 300, "sat"} end)

      :meck.new(Outputs, [:passthrough])
      :meck.expect(Outputs, :verify!, fn _, _ -> {%{unit: "sat"}, 290} end)

      assert InputsAndOutputs.verify!(MockRepo, inputs, outputs) == nil

      :meck.unload(Inputs)
      :meck.unload(Outputs)
    end
  end
end
