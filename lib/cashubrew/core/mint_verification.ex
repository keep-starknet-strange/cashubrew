defmodule Cashubrew.Mint.Verification.Amount do
  @moduledoc """
  Logic to verify user-provided amount
  """
  alias Cashubrew.Nuts.Nut02

  def verify!(amount) do
    if amount < 0 do
      raise "BlindMessageAmountShouldBePositive"
    end

    if amount > 2 ** Nut02.Keyset.max_order() do
      raise "BlindMessageAmountNotExceed2^MaxOrder"
    end
  end
end

defmodule Cashubrew.Mint.Verification.Inputs do
  @moduledoc """
  Logic to verify mint/melt user-provided payload
  """
  alias Cashubrew.Mint
  alias Cashubrew.Nuts.Nut00.BDHKE

  defp max_secret_length do
    512
  end

  def verify!(repo, inputs) do
    inner_verify!(repo, inputs, nil, MapSet.new(), 0, 0)
  end

  # Empty list
  defp inner_verify!(_repo, [], nil, _seen_secrets, _total_fee, _total_amount) do
    raise "EmptyListOfProof"
  end

  # End of list
  defp inner_verify!(_repo, [], unit, _seen_secrets, total_fee, total_amount) do
    {total_fee, total_amount, unit}
  end

  # Elems
  defp inner_verify!(repo, [head | tail], unit, seen_secrets, total_fee, total_amount) do
    Cashubrew.Mint.Verification.Amount.verify!(head)

    if head.secret == nil or head.secret == "" do
      raise "NoSecretInProof"
    end

    if head.secret > max_secret_length() do
      raise "SecretTooLong"
    end

    if Enum.member?(seen_secrets, head.secret) do
      "DuplicateProofInList"
    end

    seen_secrets.put(head.secret)

    keyset = Mint.get_keyset(repo, head.id)

    if keyset == nil do
      raise "UnkownKeyset"
    end

    # No check for first elem
    if unit != nil and unit != keyset.unit do
      raise "DifferentUnits"
    end

    key = Mint.get_key_for_amount(repo, head.id, head.amount)

    if !BDHKE.verify?(key, head."C", head.secret) do
      raise "InvalidProof"
    end

    # TODO when NUT-11 and NUT-14 are implemented: check spending condition

    inner_verify!(
      repo,
      tail,
      keyset.unit,
      seen_secrets,
      total_fee + keyset.input_fee_ppk,
      total_amount + head.amount
    )
  end
end

defmodule Cashubrew.Mint.Verification.Outputs do
  @moduledoc """
  Logic to verify protocol "outputs" (blinded messages)
  """

  # Will perform all the check required upon some user provided 'output'
  def verify!(repo, outputs) do
    inner_verify!(repo, outputs, nil, MapSet.new(), 0)
  end

  # Empty list
  defp inner_verify!(_repo, [], nil, _seen_Bs, _total_amount) do
    raise "Empty"
  end

  # End of list
  defp inner_verify!(repo, [], id, _seen_Bs, total_amount) do
    keyset = repo.get!(Schema.Keyset, id)

    if !keyset.active do
      raise "InactiveKeyset"
    end

    {keyset, total_amount}
  end

  # Elems
  defp inner_verify!(repo, [head | tail], id, seen_Bs, total_amount) do
    # No check for first elem
    if id != nil do
      if head.id != id do
        raise "DifferentKeysetIds"
      end

      if Enum.member?(seen_Bs, head."B_") do
        "Duplicate"
      end
    end

    seen_Bs.put(head."B_")

    verify_blind_message!(repo, head)
    inner_verify!(repo, tail, head.id, seen_Bs, total_amount + head.amount)
  end

  defp verify_blind_message!(repo, blind_message) do
    Cashubrew.Mint.Verification.Amount.verify!(blind_message.amount)

    if repo.exists?(Schema.Promises, blind_message."B_") do
      raise "AlreadyEmitted"
    end
  end
end

defmodule Cashubrew.Mint.Verification.InputsAndOutputs do
  @moduledoc """
  Logic to verify protocol "inputs" and "outputs" together
  """

  def verify!(repo, inputs, outputs) do
    {total_fee, input_total_amount, unit} =
      Cashubrew.Mint.Verification.Inputs.verify!(repo, inputs)

    # Empty outputs means that we are melting
    if outputs != [] do
      {output_keyset, output_total_amount} =
        Cashubrew.Mint.Verification.Outputs.verify!(repo, outputs)

      if output_keyset.unit != unit do
        raise "DifferentInputAndOutputUnit"
      end

      if output_total_amount + total_fee != input_total_amount do
        "InvalidAmountAndFee"
      end

      # TODO when NUT-11 and NUT-14 are implemented: check output spending condition
    end
  end
end

# TODO: write unit tests
