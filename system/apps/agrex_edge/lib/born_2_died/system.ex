defmodule Agrex.Born2Died.System do
  use GenServer

  require Logger
  import LogHelper

  @moduledoc """
  The Life System is a GenServer that manages the
  Life Worker and Life Channel
  """
  
  ############# PLUMBING ##################
  def via(life_id),
    do: Agrex.Registry.via_tuple({:worker, to_name(life_id)})

  def via_sup(life_id),
    do: Agrex.Registry.via_tuple({:supervisor, to_name(life_id)})

  def child_spec(state) do
    %{
      id: to_name(state.life.id),
      start: {__MODULE__, :start_link, [state]},
      type: :supervisor,
      restart: :temporary
    }
  end

  def start_link(state) do
    Logger.debug("in:state = #{inspect(state)}")
    res =
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(state.life.id)
      )

    log_res(res)
  end

  ######### API #####################

  def live(life_id),
    do: GenServer.cast(via(life_id), {:live, life_id})

  def die(life_id),
    do: GenServer.cast(via(life_id), {:die, life_id})

  def stop(life_id) do
    Supervisor.stop(via_sup(life_id), reason: :normal)
    GenServer.stop(via(life_id), reason: :normal)
  end


  ########################## CALLBACKS ####################################
  @impl GenServer
  def init(state) do
    do_supervise(state)
    {:ok, state}
  end

  @impl GenServer
  def handle_cast({:live, life_id}, state) do
    Agrex.Born2Died.Worker.live(life_id)
    {:noreply, state}
  end

  def handle_cast({:die, life_id}, state) do
    Agrex.Born2Died.Worker.die(life_id)
    {:noreply, state}
  end

  ########################## INTERNALS ########################################
  defp to_name(life_id),
    do: "life.system.#{life_id}"

  defp do_supervise(state) do
    Supervisor.start_link(
      [
        {Agrex.Born2Died.Aggregate, state},
        {Agrex.Born2Died.Emitter, state},
        {Agrex.Born2Died.Worker, state}
      ],
      name: via_sup(state.life.id),
      strategy: :one_for_one
    )
  end
end
