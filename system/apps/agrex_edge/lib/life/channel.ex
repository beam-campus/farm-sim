defmodule Agrex.Life.Channel do
  use Slipstream

  require Logger
  import LogHelper

  ############# INTERFACE ################
  def child_spec(life_id) do
    %{
      id: to_name(life_id),
      start: {__MODULE__, :start_link, [life_id]},
      restart: :temporary
    }
  end

  def start_link(life_id) do
    res = Slipstream.start_link(
      __MODULE__,
      life_id,
      name: via(life_id)
    )
    log_res(res)
  end

  ############# CALLBACKS ################
  @impl Slipstream
  def init(life_id) do
    config = Application.fetch_env!(:agrex_edge, __MODULE__)

    case connect(config) do
      {:ok, socket} ->
        {:ok, socket |> assign(:life_id, life_id) }

      {:error, reason} ->
        Logger.error("Could not start #{__MODULE__} because of " <>
          "validation failure: #{inspect(reason)}")

        :ignore
      end
  end

  ############# INTERNALS ################
  defp via(life_id),
    do: Agrex.Registry.via_tuple(to_name(life_id))

  defp to_name(life_id),
    do: "life.channel.#{life_id}"
end
