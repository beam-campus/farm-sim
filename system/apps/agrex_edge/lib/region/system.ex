defmodule Agrex.Region.System do
  use GenServer
  @moduledoc """
  Agrex.Region.System is the topmost supervisor for a Region.
  """
  require Logger

  ############## API ###################

  ############## CALLBACKS #############
  @impl GenServer
  def init(%{id: region_id} = region_init) do
    children = [
      {Agrex.Region.Farms, region_init},
      {Agrex.Region.Builder, region_init}
    ]
    Supervisor.start_link(
      children,
      name: via_sup(region_id),
      strategy: :one_for_one
    )
    {:ok, region_init}
  end

  ########### INTERNALS ############

  ############ PLUMBING ############
  def to_name(region_id),
    do: "region.system.#{region_id}"

  def via(key),
    do: Agrex.Registry.via_tuple({:region_sys, to_name(key)})

  def via_sup(key),
    do: Agrex.Registry.via_tuple({:region_sup, to_name(key)})

  def child_spec(%{id: region_id} = region_init) do
    %{
      id: to_name(region_id),
      start: {__MODULE__, :start_link, [region_init]},
      type: :supervisor,
      restart: :transient
    }
  end

  def which_children(region_id) do
    Supervisor.which_children(via_sup(region_id))
  end

  def start_link(%{id: region_id} = region_init),
    do:
      GenServer.start_link(
        __MODULE__,
        region_init,
        name: via(region_id)
      )
end
