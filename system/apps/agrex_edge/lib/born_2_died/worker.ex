defmodule Agrex.Born2Died.Worker do
  @moduledoc """
  Agrex.Born2Died.Worker is the worker process that is spawned for each Life.
  """
  use GenServer
  require Logger
  require Agrex.Born2Died.Emitter

  alias Agrex.Born2Died.Rules

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

  def move(life_id, delta_x, delta_y),
    do:
      GenServer.cast(
        via(life_id),
        {:move, delta_x, delta_y}
      )

  def get_state(life_id),
    do: GenServer.call(via(life_id), {:get_state})

  def move(life_id, delta_x, delta_y),
    do: GenServer.cast(via(life_id), {:move, delta_x, delta_y})

  ################# CALLBACKS #####################
  @impl GenServer
  def init(state) do
    Process.flag(:trap_exit, true)

    Cronlike.start_link(%{
      interval: :rand.uniform(3),
      unit: :second,
      callback_function: &do_cron/1,
      caller_state: state
    })

    Logger.debug(" \n\tBORN: #{state.life.name}  #{state.life.gender}")
    {:ok, state}
  end

  @impl GenServer
  def terminate(reason, state) do
    {:stop, reason, state}
  end

  @impl GenServer
  def handle_info({:EXIT, _from_id, reason}, state) do
    {:stop, reason, state}
  end

  @impl GenServer
  def handle_call({:get_state}, _from, state) do
    Logger.debug(" \n\tGETTING STATE: #{state.life.name}  ")
    {:reply, state, state}
  end

  ################# HANDLE_CAST #####################
  @impl GenServer
  def handle_cast({:live}, state) do
    Logger.debug(
      " \n\tLIVING [#{state.life.name}  \n\t\tage: #{state.vitals.age}, \n\t\thealth: #{state.vitals.health}]"
    )

    state =
      state
      |> Rules.calc_age()
      |> Rules.apply_age()
      |> Rules.calc_pos()

    {:noreply, do_process(state)}
  end

  @impl GenServer
  def handle_cast({:die}, state),
    do: {:noreply, do_die(state)}

  @impl GenServer
  def handle_cast({:move, delta_x, delta_y}, state),
    do: {:noreply, do_move(state, delta_x, delta_y)}

  ############################### INTERNALS #############################
  defp to_name(life_id),
    do: "born_2_died.worker.#{life_id}"

  defp do_cron(state) do
    state =
      state
      |> do_process()

    live(state.life.id)
    state
  end

  defp do_process(state) do
    state
    |> do_process_status()
    |> do_process_health()
    |> do_process_pos()
  end

  defp do_process_health(state)
       when state.vitals.health <= 0 do
    die(state.life.id)
    state
  end

  defp do_process_health(state),
    do: state

  defp do_process_pos(state) do
    move(state.life.id, :rand.uniform(3), :rand.uniform(3))
    state
  end

  # defp do_process_status(state)  do
  #   # eval_state = Agrex.Born2Died.Rules.eval(state)
  #   # case eval_state.status do
  #   #   :died ->
  #   #     Agrex.Born2Died.Emitter.emit_died(state.life.id, state)
  #   #     Agrex.Born2Died.System.die(state.life.id)
  #   #     state
  #   #   _ ->
  #   #     state
  #   # end

  #   state
  # end

  defp do_process_status(state),
    do: state

  defp do_die(state) do
    Logger.debug(
      "\n\t DIED [#{state.life.name}, \n\t\tage: #{state.vitals.age}, \n\t\thealth: #{state.vitals.health}]"
    )

    Agrex.Born2Died.System.stop(state.life.id)
    state
  end

  defp do_move(state, delta_x, delta_y) do
    s1 = " \n MOVING [#{String.slice(state.life.name, 0, 29)}\tFROM: (#{state.pos.x}, #{state.pos.y}) TO: (#{state.pos.x + delta_x}, #{state.pos.y + delta_y})]"

    new_state =
      Map.put(state, :pos, do_change_pos(state.pos, delta_x, delta_y))

    Logger.debug("#{s1}")
    new_state
  end

  defp do_change_pos(pos, delta_x, delta_y)  when is_map(pos) do
    new_pos =
      pos
      |> Map.put(:x, pos.x + delta_x)
      |> Map.put(:y, pos.y + delta_y)
    new_pos
  end

  ################# PLUMBING #####################
  def via(life_id),
    do: Agrex.Registry.via_tuple(to_name(life_id))

  def child_spec(born2died_init) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [born2died_init]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(state),
    do:
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(state.life.id)
      )
end
