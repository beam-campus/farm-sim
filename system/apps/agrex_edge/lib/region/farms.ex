defmodule Agrex.Region.Farms do
  @moduledoc """
  Agrex.Region.Farms is the top-level supervisor for the Agrex.Region subsystem.
  """
  use GenServer

  require Logger

  ############### API ###################

  def start_farm(region_id, mng_farm_init) do
    Logger.debug("\tFARM ~> #{region_id}: #{mng_farm_init.farm.name} - #{mng_farm_init.nbr_of_lives} lifes")
    DynamicSupervisor.start_child(
      via_sup(region_id),
      {Agrex.MngFarm.System, mng_farm_init}
    )

  end

  ################# CALLBACKS #####################

  @impl GenServer
  def init(region_init) do
    DynamicSupervisor.start_link(
      name: via_sup(region_init.id),
      strategy: :one_for_one
    )
    {:ok, region_init}
  end

  ################ PLUMBING ####################
  def to_name(region_id),
    do: "region.farms.#{region_id}"

  def via(key),
    do: Agrex.Registry.via_tuple({:farms, to_name(key)})

  def via_sup(key),
    do: Agrex.Registry.via_tuple({:farms_sup, to_name(key)})

  def child_spec(region_init) do
    %{
      id: to_name(region_init.id),
      start: {__MODULE__, :start_link, [region_init]},
      type: :supervisor,
      restart: :transient
    }
  end

  def start_link(%{id: region_id} = region_init),
    do:
      GenServer.start_link(
        __MODULE__,
        region_init,
        name: via(region_id)
      )
end
