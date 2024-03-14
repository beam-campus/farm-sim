defmodule Agrex.MngFarm.Aggregate do
  @moduledoc """
  Agrex.MngFarm.Aggregate is a GenServer that holds the state of a Farm.
  """
  use GenServer



  ############# CALLBACKS ######
  @impl GenServer
  def init(state) do
    {:ok, state}
  end



  ######### PLUMBING ###########
  def via(agg_id),
    do: Agrex.Registry.via_tuple({:aggregate, to_name(agg_id)})

  def to_name(agg_id),
    do: "mng_farm.aggregate.#{agg_id}"

  def child_spec(state) do
    %{
      id: via(state.id),
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }
  end
end
