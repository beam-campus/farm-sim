defmodule Agrex.ManageLandscape.Server do
  alias Agrex.Schema.Landscape
  use GenServer

  def add_region(pid, region) do
    GenServer.call(
      pid,
      {:add_region, region}
    )
  end

  def get_landscape(pid) do
    GenServer.call(
      pid,
      {:get_landscape}
    )
  end

  def start_link(args, opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      args,
      opts
    )
  end


  @impl true
  def init(args \\ []) do
    {:ok, args}
  end


  @impl true
  def handle_call({:add_region, region}, _from, state) do
    {:ok, landscape} = state
    new_state =
      landscape.regions
      |> put_in([region|landscape.regions])

    {:reply, {:ok, new_state}, new_state}
  end

  @impl true
  def handle_call({:get_landscape}, _from, state) do
    {:reply, {:ok, state}, state}
  end



end
