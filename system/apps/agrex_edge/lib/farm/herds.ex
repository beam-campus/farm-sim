defmodule Agrex.Farm.Herds do
  use GenServer

  require Logger

  import LogHelper

  # INTERFACE

  def via(farm_id) do
    Agrex.Registry.via_tuple(to_name(farm_id))
  end

  def child_spec(farm) do
    Logger.debug("in:farm = #{inspect(farm)}")

    farm_id =
      farm
      |> Keyword.get(:id)

    spec = %{
      id: to_name(farm_id),
      start: {__MODULE__, :start_link, [farm]},
      restart: :transient,
      type: :worker,
      shutdown: 500
    }

    log_spec(spec)
  end

  def start_link(%{id: farm_id} = farm) do
    GenServer.start_link(
      __MODULE__,
      farm,
      name: via(farm_id)
    )
  end

  # CALLBACKS
  def init(farm) do
    {:ok, %{farm: farm, herdes: []}}
  end

  # PRIVATE
  defp to_name(farm_id) when is_bitstring(farm_id),
    do: "farm.herdes.#{farm_id}"
end
