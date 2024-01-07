defmodule Agrex.Region.Worker do
  use GenServer

  require Logger
  import LogHelper

  ############## INTERFACE ###########
  def init_region(region_id, nbr_of_farms) do
    Logger.debug(
      "\n\n\tin:region_id = #{inspect(region_id)} \n\tin:nbr_of_farms = #{inspect(nbr_of_farms)}\n"
    )
    GenServer.cast(
      via(region_id),
      {:init_region, nbr_of_farms}
    )
  end

  def via(region_id),
    do: Agrex.Registry.via_tuple(to_name(region_id))

  @doc """
  child_spec/1 provides a child specification for Agrex.Region.Worker
  """
  def child_spec(region_id) do
    %{
      id: via(region_id),
      start: {__MODULE__, :start_link, [region_id]},
      restart: :transient,
      type: :worker
    }
  end

  def start_link(region_id) do
    res =
      GenServer.start_link(
        __MODULE__,
        region_id,
        name: via(region_id)
      )
    log_res(res)
  end

  ############## CALLBACKS ###########
  @impl GenServer
  def init(region_id) do
    Logger.debug("\n\n\tin:region_id = #{inspect(region_id)}")
    {:ok, region_id}
  end

  @impl GenServer
  def handle_cast(
        {:init_region, nbr_of_farms} = msg,
        state = region_id
      ) do
    Logger.debug("\n\n\tin:msg = #{inspect(msg)} \nin:state = #{inspect(state)}\n")

    Enum.to_list(1..nbr_of_farms)
    |> Enum.map(&do_random_farm/1)
    |> Enum.map(&do_start_farm(&1, region_id))

    {:noreply, state}
  end

  defp do_random_farm(_i),
    do: Agrex.Schema.Farm.random()

  # PRIVATES
  defp do_start_farm(farm, region_id) do
    Logger.debug("\n\n\tin:farm = #{inspect(farm)}\n\tin:region_id = #{inspect(region_id)}")
    Agrex.Region.Farms.start_farm(region_id, farm)
  end

  defp to_name(region_id),
    do: "region.worker.#{region_id}"
end
