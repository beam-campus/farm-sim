defmodule Agrex.Herd.Lives do
  use GenServer

  require Logger
  import LogHelper

  @default_vector Agrex.Schema.Vector.new(1000, 1000, 1)

  # INTERFACES
  def via(key),
    do: Agrex.Registry.via_tuple("herd.lives.#{key}")

  def via_sup(key),
    do: Agrex.Registry.via_tuple("herd.lives.sup.#{key}")

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

  def start_life(herd_id) do
    life = Agrex.Schema.Life.random()

    GenServer.cast(
      via(herd_id),
      {:start_life, life}
    )
  end

  # CALLBACKS
  @impl GenServer
  def init(herd_id) do
    Logger.debug("in:herd_id = #{inspect(herd_id)}")
    do_supervise(herd_id)
    {:ok, herd_id}
  end

  @impl GenServer
  def handle_cast({:start_life, life}, herd_id = state) do
    life_params = Agrex.Life.Params.random(@default_vector)

    Supervisor.start_child(
      via_sup(herd_id),
      {Agrex.Life.System, life_params}
    )

    {:noreply, state}
  end

  # PRIVATES

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
end


defp to
