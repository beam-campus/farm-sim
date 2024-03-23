defmodule Agrex.Landscape.Channel do
  @moduledoc """
  Agrex.MngLandscape.Channel is a GenServer that manages a channel to a landscape,
  """
  use Slipstream, restart: :temporary
  require Logger

  ############ API ##########

  ########### CALLBACKS ################
  @impl Slipstream
  def init(config) do
    {:ok, connect!(config), {:continue, :start_ping}}
  end

  ############### PLUMBING ##############
  def to_name(key) when is_bitstring(key),
    do: "landscape.channel.#{key}"

  def via(key),
    do: Agrex.Registry.via_tuple({:regions, to_name(key)})

  def start_link(args),
    do: Slipstream.start_link(__MODULE__, args, name: __MODULE__)
end
