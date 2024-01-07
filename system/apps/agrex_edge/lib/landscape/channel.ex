defmodule Agrex.Landscape.Channel do
  use Slipstream, restart: :temporary

  require Logger


  ############ API ##########

  def start_link(args) do
    Slipstream.start_link(
      __MODULE__,
      args,
      name: __MODULE__
    )
  end



  ########### IMPLEMENTATION ################
  @impl Slipstream
  def init(config) do
    {:ok, connect!(config), {:continue, :start_ping} }
  end


end
