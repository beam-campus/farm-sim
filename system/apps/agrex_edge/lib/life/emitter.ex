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

  def child_spec(life_id) do
    %{
      id: via(life_id),
      start: {__MODULE__, :start_link, [life_id]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(life_id) do
    res =
      GenServer.start_link(
        __MODULE__,
        nil,
        name: via(life_id)
      )

    log_res(res)
  end

  ############ CALLBACKS ###########
  @impl GenServer
  def init(state) do
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
