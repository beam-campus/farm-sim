defmodule Agrex.Region.Farms do
  use GenServer
  # use DynamicSupervisor

  require Logger
  import LogHelper

  ############### INTERFACE ###################
  def start_farm(region_id, farm) do
    GenServer.call(
      via(region_id),
      {:start_farm, farm}
    )
  end

  def via(region_id),
    do: Agrex.Registry.via_tuple(to_name(region_id))

  def child_spec(region_id) do
    %{
      id: to_name(region_id),
      start: {__MODULE__, :start_link, [region_id]},
      type: :supervisor,
      restart: :transient
    }
  end

  def start_link(region_id) do

    res =
      DynamicSupervisor.start_link(
        __MODULE__,
        name: via(to_sup(region_id)),
        strategy: :one_for_one
      )

    log_res(res)

    res =
      GenServer.start_link(
        __MODULE__,
        region_id,
        name: via(region_id)
      )
    log_res(res)
  end

  ################# IMPLEMENTATION #####################
  @impl GenServer
  def handle_call({:start_farm, farm}, _from, state = region_id) do
    Logger.debug("\n\n\tin:farm = #{inspect(farm)} \n\tin:region_id = #{inspect(region_id)}\n")
    res =
      DynamicSupervisor.start_child(
        via(to_sup(region_id)),
        { Agrex.Farm.System, farm: farm, region_id: region_id }
      )
    log_res(res)
    {:reply, {:ok, res}, state}
  end

  @impl GenServer
  def init(region_id) do
    Logger.debug("in:region_id = #{inspect(region_id)}")
    {:ok, region_id}
  end

  # PRIVATES
  defp to_sup(region_id),
    do: "sup.#{region_id}"

  defp to_name(region_id),
    do: "region.farms.#{region_id}"

end
