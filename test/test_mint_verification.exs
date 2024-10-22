defmodule Cashubrew.Mint.VerificationTest do
  use ExUnit.Case, async: true
  alias Cashubrew.Mint.Verification.Amount
  alias Cashubrew.Mint.Verification.Inputs
  alias Cashubrew.Mint.Verification.Outputs
  alias Cashubrew.Mint.Verification.InputsAndOutputs
  alias Cashubrew.Nuts.Nut02
  alias Cashubrew.Nuts.Nut00.BDHKE

  defmodule MockRepo do
    def get!(_schema, _id), do: %{active: true, unit: "USD"}
    def exists?(_schema, _id), do: false
  end

  defmodule MockMint do
    def get_keyset(_repo, _id), do: %{unit: "USD", input_fee_ppk: 1}
    def get_key_for_amount(_repo, _id, _amount), do: "mock_key"
  end

  describe "Amount.verify!/1" do
    test "raises error for negative amount" do
      assert_raise RuntimeError, "BlindMessageAmountShouldBePositive", fn ->
        Amount.verify!(-1)
      end
    end

    test "raises error for amount exceeding max order" do
      max_order = Nut02.Keyset.max_order()
      assert_raise RuntimeError, "BlindMessageAmountNotExceed2^MaxOrder", fn ->
        Amount.verify!(2 ** (max_order + 1))
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

    test "raises error for duplicate secrets", %{inputs: inputs} do
      duplicate_inputs = inputs ++ [%{id: "3", amount: 300, secret: "secret1", C: "C3"}]
      assert_raise RuntimeError, "DuplicateProofInList", fn ->
        Inputs.verify!(MockRepo, duplicate_inputs)
      end
    end

    test "passes for valid inputs", %{inputs: inputs} do
      :meck.new(BDHKE, [:passthrough])
      :meck.expect(BDHKE, :verify?, fn _, _, _ -> true end)

      result = Inputs.verify!(MockRepo, inputs)
      assert is_tuple(result)
      assert tuple_size(result) == 3

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

    test "raises error for different keyset ids", %{outputs: outputs} do
      invalid_outputs = outputs ++ [%{id: "2", amount: 300, B_: "B3"}]
      assert_raise RuntimeError, "DifferentKeysetIds", fn ->
        Outputs.verify!(MockRepo, invalid_outputs)
      end
    end

    test "passes for valid outputs", %{outputs: outputs} do
      result = Outputs.verify!(MockRepo, outputs)
      assert is_tuple(result)
      assert tuple_size(result) == 2
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
      :meck.expect(Inputs, :verify!, fn _, _ -> {10, 300, "USD"} end)

      :meck.new(Outputs, [:passthrough])
      :meck.expect(Outputs, :verify!, fn _, _ -> {%{unit: "EUR"}, 290} end)

      assert_raise RuntimeError, "DifferentInputAndOutputUnit", fn ->
        InputsAndOutputs.verify!(MockRepo, inputs, outputs)
      end

      :meck.unload(Inputs)
      :meck.unload(Outputs)
    end

    test "raises error for invalid amount and fee", %{inputs: inputs, outputs: outputs} do
      :meck.new(Inputs, [:passthrough])
      :meck.expect(Inputs, :verify!, fn _, _ -> {10, 300, "USD"} end)

      :meck.new(Outputs, [:passthrough])
      :meck.expect(Outputs, :verify!, fn _, _ -> {%{unit: "USD"}, 280} end)

      assert_raise RuntimeError, "InvalidAmountAndFee", fn ->
        InputsAndOutputs.verify!(MockRepo, inputs, outputs)
      end

      :meck.unload(Inputs)
      :meck.unload(Outputs)
    end

    test "passes for valid inputs and outputs", %{inputs: inputs, outputs: outputs} do
      :meck.new(Inputs, [:passthrough])
      :meck.expect(Inputs, :verify!, fn _, _ -> {10, 300, "USD"} end)

      :meck.new(Outputs, [:passthrough])
      :meck.expect(Outputs, :verify!, fn _, _ -> {%{unit: "USD"}, 290} end)

      assert InputsAndOutputs.verify!(MockRepo, inputs, outputs) == nil

      :meck.unload(Inputs)
      :meck.unload(Outputs)
    end
  end
end
