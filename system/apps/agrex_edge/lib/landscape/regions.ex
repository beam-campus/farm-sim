defmodule AgrexEdge.Landscape.Regions do
  @moduledoc """
  AgrexEdge.Landscape.Regions is the top-level supervisor for the Agrex.MngLandscape subsystem.
  """
  use GenServer

  require Logger

  ################ API ########################
  def start_region(landscape_id, region_init) do
    Logger.debug(" REGION ~> #{landscape_id}.#{region_init.id} - #{region_init.nbr_of_farms} farms")
    DynamicSupervisor.start_child(
      via_sup(landscape_id),
      {Agrex.Region.System, region_init}
    )

  end

  @doc """
  Returns the list of children supervised by this module
  """
  def which_children(key) do
    try do
      %{
        key: key,
        children:
          DynamicSupervisor.which_children(via_sup(key))
          |> Enum.reverse()
      }
    rescue
      e -> {:error, "which_children:#{inspect(e)}"}
    end
  end

  ######### CALLBACKS ############
  @impl GenServer
  def init(landscape_init) do
    DynamicSupervisor.start_link(
      name: via_sup(landscape_init.id),
      strategy: :one_for_one
    )

    {:ok, landscape_init}
  end

  ############ PLUMBING ###################
  def to_name(key) when is_bitstring(key),
    do: "landscape.regions.#{key}"

  def via_sup(key),
    do: Agrex.Registry.via_tuple({:regions_sup, to_name(key)})

  def via(key),
    do: Agrex.Registry.via_tuple({:regions, to_name(key)})

  def child_spec(landscape_init),
    do: %{
      id: to_name(landscape_init.id),
      start: {__MODULE__, :start_link, [landscape_init]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }

  def start_link(landscape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        landscape_init,
        name: via(landscape_init.id)
      )
end
