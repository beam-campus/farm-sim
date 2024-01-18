defmodule Agrex.Herd.System do
  use GenServer

  require Logger

  @moduledoc """
  Agrex.Herd.System is the top-level supervisor for the Agrex.Herd subsystem.
  """

  ############# API ################
  def get_state(herd_id),
    do:
      GenServer.call(
        via(to_name(herd_id)),
        {:get_state, herd_id}
      )

  ################ CALLBACKS #############
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
    children = [
      {Agrex.Herd.Lives, herd_id},
      {Agrex.Herd.Builder, state}
    ]

    res =
      Supervisor.start_link(
        children,
        name: via(to_sup(herd_id)),
        strategy: :one_for_one
      )

    Logger.debug("out:res = #{inspect(res)}")
  end

  ######### PLUMBING #############
  def to_name(herd_id),
    do: "herd.system.#{herd_id}"

  def to_sup(herd_id),
    do: "herd.system.sup.#{herd_id}"

  def via(key) when is_bitstring(key),
    do: Agrex.Registry.via_tuple(key)

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
      name: via(to_name(herd_id))
    )
  end
end
