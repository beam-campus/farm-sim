defmodule Agrex.Born2Died.Emitter do
  use GenServer

  @moduledoc """
  Registry is a simple key-value store that allows processes to be registered
  """
  require Logger

  ############ API ###########
  # def await_join(edge_id, life_id) do
  #   GenServer.call(
  #     via(life_id),
  #     {:join, edge_id}
  #   )
  # end


  def emit_born(life_id, fact) do
    Agrex.Edge.Client.publish(
      life_id,
      "edge_born_v1",
      fact
    )
    # GenServer.cast(
    #   via(life_id),
    #   {:emit_born, fact}
    # )
  end


  def emit_died(life_id, b2d_state),
    do:
      GenServer.cast(
        via(life_id),
        {:emit_died, b2d_state}
      )


  def via(life_id),
    do: Agrex.Registry.via_tuple({:emitter, to_name(life_id)})

  def child_spec(state),
    do: %{
      id: via(state.life.id),
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }

  def start_link(state),
    do:
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(state)
      )

  ############ CALLBACKS ###########
  @impl GenServer
  def init(state),
    do: {:ok, state}

  ############ INTERNALS ###########
  defp to_name(life_id),
    do: "born_2_died.emitter:#{life_id}"
end
