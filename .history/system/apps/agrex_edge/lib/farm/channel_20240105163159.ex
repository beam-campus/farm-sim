defmodule Agrex.Farm.Channel do
  use GenServer

  @moduledoc """
   This module provides functionality for handling communication channels in the Agrex Farm system.
  """

###### API ######
  @doc """
   Starts the channel process.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [farm_id], name: via(farm_id))
  end

  ##### Callbacks #####

  ##### Internals #####



end
