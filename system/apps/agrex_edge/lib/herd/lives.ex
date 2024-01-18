defmodule Agrex.Herd.Lives do
  use GenServer

  @moduledoc """
  Agrex.Herd.Lives is the Lives Actor for the Agrex.Herd subsystem.
  """
  require Logger
  import LogHelper

  @default_vector Agrex.Schema.Vector.new(1000, 1000, 1)

  ############# API ################
  def start_life(edge_id, herd_id) do
    life = Agrex.Schema.Life.random()
    GenServer.cast(
      via(herd_id),
      {:start_life, edge_id, life}
    )
  end

  ########### CALLBACKS #############
  @impl GenServer
  def init(herd_id) do
    Logger.debug("in:herd_id = #{inspect(herd_id)}")
    do_supervise(herd_id)
    {:ok, %{herd_id: herd_id}}
  end

  @impl GenServer
  def handle_cast({:start_life, edge_id, life}, %{herd_id: herd_id} = state) do
    life_state = Agrex.Life.State.random(edge_id, @default_vector, life)

    Supervisor.start_child(
      via_sup(herd_id),
      {Agrex.Life.System, life_state}
    )

    {:noreply, state}
  end

  ########## INTERNALS ############
  defp do_supervise(herd_id) do
    Logger.debug("in:herd_id = #{inspect(herd_id)}")

    res =
      Supervisor.start_link(
        __MODULE__,
        name: via_sup(herd_id),
        strategy: :one_for_one
      )

    Logger.debug("out:res = #{inspect(res)}")
  end

  ######### PLUMBING #############
  def via(key),
    do: Agrex.Registry.via_tuple({:worker, to_name(key)})

  def via_sup(key),
    do: Agrex.Registry.via_tuple({:supervisor, to_name(key)})

  def child_spec(herd_id) do
    %{
      id: to_name(herd_id),
      start: {__MODULE__, :start_link, [herd_id]},
      restart: :transient,
      type: :supervisor
    }
  end

  def start_link(herd_id) do
    res =
      GenServer.start_link(
        __MODULE__,
        herd_id,
        name: via(herd_id)
      )

    log_res(res)
  end

  def to_name(herd_id),
    do: "herd.lives.#{herd_id}"
end
