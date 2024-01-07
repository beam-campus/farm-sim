defmodule Agrex.Farm.Channel do
  use GenServer

  @moduledoc """
   This module provides functionality for handling communication channels in the Agrex Farm system.
  """

  ###### API ######
  @doc """
   Starts the channel process.
  "
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
  ##### Callbacks #####

  ##### Internals #####



end
