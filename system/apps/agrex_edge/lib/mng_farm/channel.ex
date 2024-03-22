defmodule Agrex.MngFarm.Channel do
  use GenServer

  @moduledoc """
   This module provides functionality for handling communication channels in the Agrex Farm system.
  """

  require Logger

  ###### API ######
  def via(farm_id),
    do: {:via, Registry, to_name(farm_id)}

  @doc """
   Starts the channel process.
  """
  def start_link(farm_id) do
    GenServer.start_link(
      __MODULE__,
      [farm_id],
      name: via(farm_id)
    )
  end

  ##### Callbacks #####
  @impl GenServer
  def init(farm_id) do
    {:ok, farm_id}
  end

  ##### Internals #####
  defp to_name(farm_id),
    do: "farm.channel.#{farm_id}"
end
