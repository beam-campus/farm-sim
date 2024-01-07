defmodule Agrex.Region.Builder do
  use GenServer
  require Logger
  import LogHelper

  # INTERFACE

  def via(region_id),
    do: Agrex.Registry.via_tuple(to_name(region_id))

  def child_spec(region_id) do
    %{
      id: to_name(region_id),
      start: {__MODULE__, :start_link, [region_id]},
      restart: :temporary,
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

  # CALLBACKS

  @impl GenServer
  def init(region_id) do
    Logger.debug("\n\n\tin:region_id = #{inspect(region_id)} \n")

    res =
      Agrex.Region.Worker.init_region(
        region_id,
        :rand.uniform(Agrex.Limits.max_farms())
      )

    Logger.debug("\n\n\tout:res = #{inspect(res)}\n")
    {:ok, region_id}
  end

  # PRIVATES
  defp to_name(region_id),
    do: "region.builder.#{region_id}"
end
