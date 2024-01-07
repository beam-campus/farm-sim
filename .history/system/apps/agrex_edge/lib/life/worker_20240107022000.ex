defmodule Agrex.Life.Worker do
  use GenServer

  require Logger
  import LogHelper

  alias Agrex.Life.Rules

  ################ INTERFACE ###############
  def live(life_id),
    do:
      GenServer.cast(
        via(life_id),
        {:live}
      )

  def die(life_id),
    do:
      GenServer.cast(
        via(life_id),
        {:die}
      )

  def get_state(life_id),
    do: GenServer.call(via(life_id), {:get_state})

  def via(life_id),
    do: Agrex.Registry.via_tuple(to_name(life_id))

  def child_spec(life_params) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [life_params]},
      type: :worker,
      restart: :transient
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


  ################# CALLBACKS #####################
  @impl GenServer
  def init(state) do
    Cronlike.start_link(%{
      interval: :rand.uniform(5),
      unit: :second,
      callback_function: &do_live/1,
      caller_state: state
    })

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  @impl GenServer
  def handle_cast({:live}, state) do
    state =
      state
      |> Rules.calc_age()
      |> Rules.apply_age()
    {:noreply, do_process(state)}
  end

  @impl GenServer
  def handle_cast({:die}, state),
    do: {:noreply, do_die(state)}

  ############################### INTERNALS #############################
  defp to_name(life_id),
    do: "life.worker.#{life_id}"

  defp do_live(state) do
    Logger.debug("\n [#{state.life.name}] is alive! ")
    # live(state.life.id)
    Agrex.Life.System.live(state.life.id)
    state
  end

  defp do_process(state) do
    state
    |> do_process_health()
  end

  defp do_process_health(state) do
    if state.vitals.health <= 0 do
      Agrex.Life.System.die(state.life.id)
    end
    state
  end

  defp do_die(state) do
    Logger.debug("\n [#{state.life.name}] has died")
    Agrex.Life.System.stop(state.life.id)
    state
  end

end
