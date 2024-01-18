defmodule Agrex.Herd.Builder do
  use GenServer

  @moduledoc """
  Agrex.Herd.Builder is the Builder Actor for the Agrex.Herd subsystem.
  """
  ############# API ################

  ########### CALLBACKS #############
  @impl GenServer
  def init(%{id: herd_id, size: size} = state) do
    Enum.to_list(1..size)
    |> Enum.each(&do_start_life(&1, herd_id))

    {:ok, state}
  end

  #############  INTERNALS #############
  defp do_start_life(_index, herd_id),
    do: Agrex.Herd.Lives.start_life(herd_id)

  ########## PLUMBING #############
  def via(key) when is_bitstring(key),
    do: Agrex.Registry.via_tuple(key)

  def to_name(herd_id) when is_bitstring(herd_id),
    do: "herd.builder.#{herd_id}"

  def child_spec(%{id: herd_id} = state) do
    %{
      id: to_name(herd_id),
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(%{id: herd_id} = state) do
    GenServer.start_link(
      __MODULE__,
      state,
      name: via(to_name(herd_id))
    )
  end
end
