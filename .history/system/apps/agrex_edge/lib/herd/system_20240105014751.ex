defmodule Agrex.Herd.System do
  use GenServer
  require Logger
  import LogHelper

  # INTERFACE
  def via(key) when is_bitstring(key),
    do: Agrex.Registry.via_tuple(key)

  def child_spec(%{herd_id: herd_id} = herd_params) do
    %{
      id: to_name(herd_id),
      start: {__MODULE__, :start_link, [herd_params]},
      restart: :permanent,
      type: :supervisor
    }
  end

  def start_link(%{herd_id: herd_id} = herd_params) do
    GenServer.start_link(
      __MODULE__,
      herd_params,
      name: via(to_name(herd_id))
    )
  end

  # CALLBACKS
  def init(herd_params) do
    Logger.debug("in:herd_params = #{inspect(herd_params)}")
    do_supervise(herd_params)
    {:ok, herd_params}
  end

  # PRIVATES
  defp to_name(herd_id),
    do: "herd.system.#{herd_id}"

  defp to_sup(herd_id),
    do: "herd.system.sup.#{herd_id}"

  defp do_supervise(%{herd_id: herd_id} = herd_params) do
    children = [
      {Agrex.Herd.Lifes, herd_id},
      {Agrex.Herd.Builder, herd_params}
    ]
    res =
      Supervisor.start_link(
        children,
        name: via(to_sup(herd_id)),
        strategy: :one_for_one
      )

    Logger.debug("out:res = #{inspect(res)}")
  end
end
