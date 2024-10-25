defmodule Cashubrew.Nuts.Nut03.Impl do
  @moduledoc """
  Implementation and structs of the NUT-03
  """
  alias Cashubrew.Mint
  alias Cashubrew.Nuts.Nut00

  @spec swap!(Nut00.Proof, Nut00.BlindedMessage) :: Nut00.BlindSignature
  def swap!(inputs, outputs) do
    repo = Application.get_env(:cashubrew, :repo)

    Mint.Verification.InputsAndOutputs.verify!(repo, inputs, outputs)

    promises =
      case Mint.create_blinded_signatures(repo, outputs) do
        {:ok, promises} -> promises
        {:error, reason} -> raise reason
      end

    Mint.register_used_proofs(repo, inputs)

    promises
  end
end
