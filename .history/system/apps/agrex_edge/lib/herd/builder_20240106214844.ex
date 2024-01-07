defmodule Agrex.Herd.Builder do
  use GenServer

  # INTERFACE
  def via(key) when is_bitstring(key),
    do: Agrex.Registry.via_tuple(key)

  def child_spec(%{herd_id: herd_id} = herd_params) do
    %{
      id: to_name(herd_id),
      start: {__MODULE__, :start_link, [herd_params]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(%{herd_id: herd_id} = herd_params) do
    GenServer.start_link(
      __MODULE__,
      herd_params,
      name: via(to_name(herd_id))
    )
  end

  # CALLBACKS
  def init(%{herd_id: herd_id, size: size} = herd_params) do
    Enum.to_list(1..size)
    |> Enum.each(&do_start_life(&1, herd_id))

    {:ok, herd_params}
  end

  # INTERNALS
  defp to_name(herd_id) when is_bitstring(herd_id),
    do: "herd.builder.#{herd_id}"

  defp do_start_life(_index, herd_id),
    do: Agrex.Herd.Lifes.start_life(herd_id)
end
