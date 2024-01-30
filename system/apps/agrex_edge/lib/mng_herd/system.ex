defmodule Agrex.MngHerd.System do
  use GenServer

  require Logger

  @moduledoc """
  Agrex.MngHerd.System is the top-level supervisor for the Agrex.MngHerd subsystem.
  """

  ############# API ################
  def start_born2died(herd_id, born2died_state) do
    GenServer.cast(
      via(herd_id),
      {:start_born2died, herd_id, born2died_state}
    )
  end

  def get_state(herd_id),
    do:
      GenServer.call(
        via(herd_id),
        {:get_state, herd_id}
      )

  ################ CALLBACKS #############
  @impl GenServer
  def handle_cast({:start_born2died, herd_id, born2died_state}, state) do
    Supervisor.start_child(
      via_sup(herd_id),
      {Agrex.Born2Died.System, born2died_state}
    )
    {:noreply, state}
  end


  @impl GenServer
  def init(state) do
    Logger.debug("in:state = #{inspect(state)}")
    do_supervise(state)
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:get_state, _herd_id}, _from, state) do
    {:reply, state, state}
  end

  ########## INTERNALS ############
  defp do_supervise(%{id: herd_id} = state) do
    Logger.debug("in:state = #{inspect(state)}")

    children = [
      # {Agrex.MngHerd.Lives, herd_id},
      {Agrex.MngHerd.Builder, state}
    ]

    res =
      Supervisor.start_link(
        children,
        name: via_sup(herd_id),
        strategy: :one_for_one
      )

    Logger.debug("out:res = #{inspect(res)}")
  end

  ######### PLUMBING #############
  def to_name(herd_id),
    do: "herd.system.#{herd_id}"


  def via(key) when is_bitstring(key),
    do: Agrex.Registry.via_tuple({:system, to_name(key)})

 def via_sup(key) when is_bitstring(key),
    do: Agrex.Registry.via_tuple({:supervisor, to_name(key)})


  def child_spec(%{id: herd_id} = state) do
    %{
      id: to_name(herd_id),
      start: {__MODULE__, :start_link, [state]},
      restart: :permanent,
      type: :supervisor
    }
  end

  def start_link(%{id: herd_id} = state) do
    GenServer.start_link(
      __MODULE__,
      state,
      name: via(herd_id)
    )
  end
end
