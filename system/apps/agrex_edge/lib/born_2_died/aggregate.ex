defmodule Agrex.Born2Died.Aggregate do
  use GenServer

  @moduledoc """
  Aggregate is a GenServer that holds the state of a Life.
  """

  ############## COMMAND HANDLERS ####
  def build_state(agg_id) do
    GenServer.call(via_tuple(agg_id), :build_state)
  end

  def execute(
        "agrex.born2died.initialize.v1",
        %{meta: %{agg_id: agg_id}} = hope
      ) do
    GenServer.call(
      via_tuple(agg_id),
      {:initialize, hope}
    )
  end

  ############## MUTATORS ##########
  defp source_event(
         %{
           topic: "agrex.born2died.born.v1",
           meta: _meta,
           payload: _payload
         } = _event,
         state
       ) do
    state
    |> Map.put(:status, Flags.set(state.status, 1))
  end

  ################ CALLBACKS #######
  @impl GenServer
  def handle_call(
        :build_state,
        _from,
        %{state: old_state, events: events} = _state
      ) do
    state =
      events
      |> Enum.reduce(old_state, &source_event(&1, &2))
    {:reply, [state: state, events: events], %{state: state, events: events}}
  end

  @impl GenServer
  def handle_call(
        {:initialize, %{meta: meta, payload: payload} = _hope},
        _from,
        %{status: status, events: events} = state
      ) do
    case Flags.has(status, 1) do
      true ->
        {:reply, state, state}

      false ->
        meta |> Map.put(:order, 1)

        new_state =
          state
          |> Map.put(:events, [
            events ++ Agrex.Schema.Fact.new("agrex.born2died.born.v1", meta, payload)
          ])

        {:reply, new_state, new_state}
    end
  end

  @impl GenServer
  def init(state) do
    {:ok,
     %{
       state: state,
       events: []
     }}
  end

  ########## PLUMBING ##############
  def start_link(%{id: agg_id} = state) do
    GenServer.start_link(
      __MODULE__,
      state,
      name: via_tuple(agg_id)
    )
  end

  def via_tuple(agg_id) do
    Agrex.Registry.via_tuple({:aggregate, agg_id})
  end

  def child_spec(%{id: agg_id} = state) do
    %{
      id: via_tuple(agg_id),
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }
  end
end
