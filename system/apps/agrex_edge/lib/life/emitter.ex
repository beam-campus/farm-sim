defmodule Agrex.Life.Emitter do
  use GenServer

  @moduledoc """
  Registry is a simple key-value store that allows processes to be registered
  """
  require Logger
  import LogHelper

  ############ API ###########
  def await_join(edge_id, life_id) do
    GenServer.call(
      via(life_id),
      {:join, edge_id}
    )
  end

  def emit_born(life_id, fact) do
    GenServer.cast(
      via(life_id),
      {:emit_born, fact}
    )
  end

  def await_emit_born(life_id, fact) do
    GenServer.call(
      via(life_id),
      {:emit_born, fact}
    )
  end

  def emit_died(life_id, fact) do
    GenServer.cast(
      via(life_id),
      {:emit_died, fact}
    )
  end

  def await_emit_died(life_id, fact) do
    GenServer.call(
      via(life_id),
      {:emit_died, fact}
    )
  end

  def via(life_id),
    do: Agrex.Registry.via_tuple({:emitter, to_name(life_id)})

  def child_spec(state) do
    %{
      id: via(state.life.id),
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(state) do
    res =
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(state)
      )

    log_res(res)
  end

  ############ CALLBACKS ###########

  @impl GenServer
  def init(state),
    do: {:ok, state}

  @impl GenServer
  def handle_cast({:emit_born, fact}, state) do
    Agrex.Edge.Client.emit_born(state.edge_id, fact)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:emit_died, fact}, state) do
    Agrex.Edge.Client.emit_died(state.edge_id, fact)
    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:emit_born, fact}, _from, state) do
    res = Agrex.Edge.Client.await_emit_born(state.edge_id, fact)
    {:reply, res, state}
  end

  @impl GenServer
  def handle_call({:emit_died, fact}, _from, state) do
    res = Agrex.Edge.Client.await_emit_died(state.edge_id, fact)
    {:reply, res, state}
  end

  @impl GenServer
  def handle_call({:join, edge_id}, _from, state) do
    res = Agrex.Edge.Client.await_join(edge_id)
    {:reply, res, state}
  end

  ############ INTERNALS ###########
  defp to_name(life_id),
    do: "life.emitter:#{life_id}"
end
