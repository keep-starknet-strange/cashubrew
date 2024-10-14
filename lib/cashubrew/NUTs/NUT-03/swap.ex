defmodule Cashubrew.Nuts.Nut03.Swap do
  @moduledoc """
  Implementation and structs of the NUT-03
  """
  alias Cashubrew.Mint

  defmodule PostSwapRequest do
    @moduledoc """
    The body of the post swap rest request
    """
    @enforce_keys [:inputs, :outputs]
    defstruct [:inputs, :outputs]
  end

  defmodule PostSwapResponse do
    @moduledoc """
    The body of the post swap rest response
    """
    @enforce_keys [:signatures]
    defstruct [:signatures]
  end

  def swap(%PostSwapRequest{inputs: proofs, outputs: blinded_messages}) do
    if Mint.check_proofs_are_used?(proofs) do
      raise "SwapProofIsAlreadyUsed"
    end

    if ListHasDuplicates.check?(blinded_messages) do
      raise "SwapHasDuplicateOutputs"
    end

    total_amount_proofs = Enum.reduce(proofs, 0, fn p, acc -> acc + p.amount end)

    signatures =
      case Mint.create_blinded_signatures(blinded_messages) do
        {:ok, signatures} -> signatures
        {:error, reason} -> raise reason
      end

    total_amount_signatures = Enum.reduce(signatures, 0, fn bm, acc -> acc + bm.amount end)

    if total_amount_proofs != total_amount_signatures do
      raise "SwapAmountMismatch"
    end

    Mint.register_used_proofs(proofs)

    %PostSwapResponse{signatures: signatures}
  end
end

defmodule ListHasDuplicates do
  @moduledoc """
  Util logic to check if list contains duplicates
  """
  def check?(list),
    do: check?(list, %{})

  defp check?([], _) do
    false
  end

  defp check?([head | tail], set) do
    case set do
      %{^head => true} -> true
      _ -> check?(tail, Map.put(set, head, true))
    end
  end
end
