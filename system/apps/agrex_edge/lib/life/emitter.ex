defmodule Agrex.Life.Emitter do
  use GenServer

  @moduledoc """
  Registry is a simple key-value store that allows processes to be registered
  """
  require Logger
  import LogHelper

  ############ API ###########
  def emit_born(life_id, {:emit_born, fact}) do
    GenServer.cast(
      via(life_id),
      {:emit_born, fact}
    )
  end

  def emit_died(life_id, {:emit_died, fact}) do
    GenServer.cast(
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
  def init(state) do
    Agrex.Life.Client.join_edge(state.edge_id)
    {:ok, state}
  end

  @impl GenServer
  def handle_cast({:emit_born, fact}, state) do
    Agrex.Edge.Client.emit_born(fact)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:emit_died, fact}, state) do
    Agrex.Edge.Client.emit_died(fact)
    {:noreply, state}
  end

  ############ INTERNALS ###########
  defp to_name(life_id),
    do: "life.emitter:#{life_id}"
end
