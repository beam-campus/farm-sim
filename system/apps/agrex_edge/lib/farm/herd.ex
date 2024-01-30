defmodule Agrex.Farm.Herd do
  use DynamicSupervisor

  alias Agrex.Schema.Life

  require Logger

  @moduledoc """
  The Agrex.Far.Herd.System supervises the Lives in a Herd.
  """

  def start_link(%Agrex.Schema.Farm{nbr_of_life: nbr_of_life} = farm) do
    Logger.info("in:farm = #{inspect(farm)}.")

    res =
      DynamicSupervisor.start_link(
        __MODULE__,
        farm,
        name: __MODULE__
      )

    case res do
      {:ok, _} ->
        populate(nbr_of_life)
        res

      _ ->
        res
    end
  end

  # @impl true
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end

  def populate(nbr_of_lives) do
    for cnt <- 1..nbr_of_lives do
      Logger.debug("Populating Herd. Life ##{cnt}")
      life_worker(Agrex.Schema.Life.random())
    end
  end

  def life_worker(%Life{} = life) do
    case res =
           DynamicSupervisor.start_child(
             __MODULE__,
             Agrex.Born2Died.Worker.child_spec(life)
           ) do
      {:ok, pid} ->
        pid

      {:error, {:already_started, pid}} ->
        pid

      _ ->
        Logger.error("Herd.System life_worker(#{inspect(life)}) returned  #{inspect(res)} ")
    end
  end


  def which_children() do
    DynamicSupervisor.which_children(__MODULE__)
  end

  @impl true
  def init(init_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [init_arg]
    )
  end
end
