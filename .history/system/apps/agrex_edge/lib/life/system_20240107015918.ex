defmodule Agrex.Life.System do
  use GenServer

  require Logger
  import LogHelper

  @moduledoc """
  

  ######### API #####################

  def live(life_id),
    do: GenServer.cast(via(life_id), {:live, life_id})

  def die(life_id),
    do: GenServer.cast(via(life_id), {:die, life_id})

  def stop(life_id) do
    Supervisor.stop(via_sup(life_id), reason: :normal)
    GenServer.stop(via(life_id), reason: :normal)
  end

  def child_spec(state) do
    %{
      id: to_name(state.life.id),
      start: {__MODULE__, :start_link, [state]},
      type: :supervisor,
      restart: :temporary
    }
  end

  def start_link(state) do
    res =
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(state.life.id)
      )

    log_res(res)
  end

  ########################## CALLBACKS ####################################
  @impl GenServer
  def init(life_params) do
    do_supervise(life_params)
    {:ok, life_params}
  end

  @impl GenServer
  def handle_cast({:live, life_id}, state) do
    Agrex.Life.Worker.live(life_id)
    {:noreply, state}
  end

  def handle_cast({:die, life_id}, state) do
    Agrex.Life.Worker.die(life_id)
    {:noreply, state}
  end

  ########################## INTERNALS ########################################
  defp via(life_id),
    do: Agrex.Registry.via_tuple(to_name(life_id))

  defp via_sup(life_id),
    do: Agrex.Registry.via_tuple(to_sup(life_id))

  defp to_name(life_id),
    do: "life.system.#{life_id}"

  defp to_sup(life_id),
    do: "life.system.sup.#{life_id}"

  defp do_supervise(state) do
    Supervisor.start_link(
      [
        {Agrex.Life.Channel, state.life.id},
        {Agrex.Life.Worker, state}
      ],
      name: via_sup(state.life.id),
      strategy: :one_for_one
    )
  end
end
