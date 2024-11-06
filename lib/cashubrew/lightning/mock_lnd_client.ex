defmodule Cashubrew.LightingNetwork.MockLnd do
  @moduledoc """
    Mock client to compile test without running an lnd node 
  """
  use GenServer
  require Logger

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def create_invoice!(_amount, _unit, _description) do
    %{}
  end
end
