defmodule Agrex.MngFarm.Herd do
  use GenServer

  alias Agrex.Schema.Life

  require Logger

  @moduledoc """
  The Agrex.Far.Herd.System supervises the Lives in a Herd.
  """

  ################# API ##################
  def populate(mng_farm_init) do
    Enum.to_list(1..mng_farm_init.nbr_of_lives)
    |> Enum.map(&do_new_life/1)
    |> Enum.each(&do_start_born2died(mng_farm_init, &1))
  end

  def which_children(mng_farm_id) do
    DynamicSupervisor.which_children(via_sup(mng_farm_id))
  end

  ################# CALLBACKS ##################
  @impl GenServer
  def init(mng_farm_init) do
    DynamicSupervisor.start_link(
      name: via_sup(mng_farm_init.id),
      strategy: :one_for_one
    )

    {:ok, mng_farm_init}
  end

  ############### INTERNALS ################
  defp do_new_life(_) do
    Life.random()
  end

  defp do_start_born2died(mng_farm_init, life) do
    res = DynamicSupervisor.start_child(
      via_sup(mng_farm_init.id),
      {Agrex.Born2Died.Worker, Agrex.Born2Died.State.from_life(life)}
    )
  end

  ################# PLUMBING ##################
  def start_link(mng_farm_init),
    do:
      GenServer.start_link(
        __MODULE__,
        mng_farm_init,
        name: via(mng_farm_init.id)
      )

  def child_spec(mng_farm_init) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [mng_farm_init]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end

  def to_name(mng_farm_id),
    do: "mng_farm.herd.#{mng_farm_id}"

  def via(mng_farm_id),
    do: Agrex.Registry.via_tuple({:mng_farm_herd, to_name(mng_farm_id)})

  def via_sup(mng_farm_id),
    do: Agrex.Registry.via_tuple({:mng_farm_herd_sup, to_name(mng_farm_id)})
end
