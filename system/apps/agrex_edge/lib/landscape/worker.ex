defmodule Agrex.Landscape.Worker do
  use GenServer

  require Logger
  import LogHelper

  ########## API #######################
  def child_spec(init_arg) do
    Logger.debug("in:init_arg = #{inspect(init_arg)}")
    spec = %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [init_arg, []]},
      type: :worker
    }
    log_spec(spec)
  end

  def start_link(landscape_params, opts \\ []) do
    Logger.info("in:landscape_params=#{inspect(landscape_params)}, in:opts=#{inspect(opts)}")

    res =
      GenServer.start_link(
        __MODULE__,
        landscape_params,
        name: __MODULE__
      )

    log_res(res)

    case res do
      {:ok, _} ->
        init_landscape()
        res

      _ ->
        res
    end
  end

  def init_landscape(),
    do: GenServer.cast(__MODULE__, {:init_landscape})

  ########### SERVER
  @impl GenServer
  def init(landscape) do
    {:ok, landscape}
  end

  @impl GenServer
  def handle_cast(
        {:init_landscape},
        [
          name: _name,
          nbr_of_regions: nbr_of_regions,
          min_area: min_area,
          min_people: min_people
        ] = state
      ) do
    Logger.debug("state=#{inspect(state)}")

    Agrex.Countries.Cache.farmable_countries(min_area, min_people)
    |> Enum.take_random(nbr_of_regions)
    |> Enum.map(&do_start_region(&1))

    {:noreply, state}
  end

  defp do_start_region(region_name) do
    Logger.debug("in:region_name = #{region_name}")

    region_id =
      region_name
      |> String.replace(" ", "_")
      |> String.downcase()

    res = Agrex.Landscape.Regions.start_region_system(region_id)
    log_res(res)
  end
end
