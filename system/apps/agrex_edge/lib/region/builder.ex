defmodule Agrex.Region.Builder do
  use GenServer
  @moduledoc """
  Agrex.Region.Builder is a GenServer that constructs an Agrex.Region
  by spawning Agrex.MngFarm Processes.
  """

  require Logger



  ############# CALLBACKS ############
  @impl GenServer
  def init(region_init) do
    do_build(region_init)
    {:ok, region_init}
  end

  ############# INTERNALS ############
  defp do_build(region_init) do
    Enum.to_list(1..region_init.nbr_of_farms)
    |> Enum.map(&do_random_mng_farm_init/1)
    |> Enum.each(&Agrex.Region.Farms.start_farm(region_init.id, &1))
  end

  defp do_random_mng_farm_init(_i),
    do: Agrex.MngFarm.InitParams.random(Agrex.Schema.Farm.random())

  ################# PLUMBING ################
  def to_name(key),
    do: "region.builder.#{key}"

  def via(region_id),
    do: Agrex.Registry.via_tuple({:builder, to_name(region_id)})

  def child_spec(%{id: region_id} = region_init) do
    %{
      id: to_name(region_id),
      start: {__MODULE__, :start_link, [region_init]},
      restart: :temporary,
      type: :worker
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
