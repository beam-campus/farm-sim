defmodule Agrex.Farm.System do
  use Supervisor

  @moduledoc """
  The Agrex.Farm.System supervises the Agrex.Farm.Channel and the Agrex.Farm.Herd.
  """

  require Logger
  import LogHelper

  ################### CALLBACKS ###################
  @impl Supervisor
  def init(args) do
    Logger.debug("\n\n\tin:args = #{inspect(args)}\n\n")
    [farm: farm, region_id: _region_id] = args

    %{id: farm_id} = farm

    children =
      [
        {Agrex.Farm.Channel, farm.id},
        {Agrex.Farm.Herd, farm}
      ]

    Supervisor.init(children,
      name: via(farm_id),
      strategy: :one_for_one
    )
  end

  ########### INTERNALS ############
  defp to_name(farm_id),
    do: "farm.system.#{farm_id}"

  ############ PLUMBING ############
  def via(farm_id),
    do: Agrex.Registry.via_tuple(to_name(farm_id))

  def child_spec(farm_region) do
    [farm: farm, region_id: _region_id] = farm_region
    Logger.debug("\n\n\tin:farm_region = #{inspect(farm_region)}\n")

    %{id: farm_id} = farm

    spec = %{
      id: to_name(farm_id),
      start: {__MODULE__, :start_link, [farm_region]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }

    log_spec(spec)
  end

  def start_link(farm_region),
    do:
      Supervisor.start_link(
        __MODULE__,
        farm_region
      )
end
