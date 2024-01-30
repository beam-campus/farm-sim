defmodule Agrex.Region.System do
  @moduledoc """
  Agrex.Region.System is a data structure that represents a Region in the Agrex system.
  """
  use GenServer

  require Logger


  # INTERFACES

  def via(key),
    do: Agrex.Registry.via_tuple(to_name(key))

  def child_spec(region_id) do
    %{
      id: to_name(region_id),
      start: {__MODULE__, :start_link, [region_id]},
      type: :supervisor,
      restart: :transient
    }
  end

  def which_children(region_id) do
    Supervisor.which_children(via(to_sup(region_id)))
  end

  def start_link(region_id) do
    Logger.debug("\n\tin:region_id = #{inspect(region_id)}")
    children = [
      {Agrex.Region.Farms, region_id},
      {Agrex.Region.Worker, region_id},
      {Agrex.Region.Builder, region_id},
    ]
    res = Supervisor.start_link(
      children,
      name: via(to_sup(region_id)),
      strategy: :one_for_one
    )
    inspect(res)
  end

  # CALLBACKS
  @impl GenServer
  def init(init_arg) do
    Logger.debug("\n\n\tin:init_arg = #{inspect(init_arg)}\n")
    {:ok, init_arg}
  end


  # PRIVATES
  defp to_name(region_id),
    do: "region.system.#{region_id}"

    defp to_sup(region_id),
    do: "sup.#{region_id}"


end
