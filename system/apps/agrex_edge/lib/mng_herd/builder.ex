defmodule Agrex.MngHerd.Builder do
  @moduledoc """
  Agrex.MngHerd.Builder is the Builder Actor for the Agrex.MngHerd subsystem.
  """
  use GenServer

  require Logger

  ########### CALLBACKS #############
  @impl GenServer
  def init(%{size: size} = state) do
    Enum.to_list(1..size)
    |> Enum.each(&do_start_born2died(&1, state))
    {:ok, state}
  end

  #############  INTERNALS #############
  defp do_start_born2died(_index, %{id: herd_id, map: map, edge_id: edge_id} = state) do
    Logger.debug("in:state = #{inspect(state)}")
    life = Agrex.Schema.Life.random()
    born2died_state = Agrex.Born2Died.State.random(edge_id, map, life)
    Agrex.MngHerd.System.start_born2died(herd_id, born2died_state)
  end



  ########## PLUMBING #############
  def via(key) when is_bitstring(key),
    do: Agrex.Registry.via_tuple({:worker, to_name(key)})

  def to_name(herd_id) when is_bitstring(herd_id),
    do: "mng_herd.builder.#{herd_id}"

  def child_spec(%{id: herd_id} = state) do
    %{
      id: to_name(herd_id),
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(%{id: herd_id} = state) do
    GenServer.start_link(
      __MODULE__,
      state,
      name: via(herd_id)
    )
  end
end
