defmodule Agrex.Landscape.Channel do
  @moduledoc """
  Agrex.MngLandscape.Channel is a GenServer that manages a channel to a landscape,
  """
  use Slipstream, restart: :temporary
  require Logger

  ############ API ##########
  def start_link(args),
    do: Slipstream.start_link(__MODULE__, args, name: __MODULE__)

  ########### CALLBACKS ################
  @impl Slipstream
  def init(config) do
    {:ok, connect!(config), {:continue, :start_ping}}
  end

end
