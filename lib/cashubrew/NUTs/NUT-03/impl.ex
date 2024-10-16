defmodule Cashubrew.Nuts.Nut03.Impl do
  @moduledoc """
  Implementation and structs of the NUT-03
  """
  alias Cashubrew.Mint
  alias Cashubrew.Nuts.Nut00

  @spec swap!(Nut00.Proof, Nut00.BlindedMessage) :: Nut00.BlindSignature
  def swap!(proofs, blinded_messages) do
    repo = Application.get_env(:cashubrew, :repo)

    if Mint.check_proofs_are_used?(repo, proofs) do
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

    Mint.register_used_proofs(repo, proofs)

    signatures
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
