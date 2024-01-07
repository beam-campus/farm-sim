defmodule Agrex.Life.Client do
  use Slipstream

  require Logger
  import LogHelper

  @moduledoc """
  Agrex.Edge.Client is the client-side of the Agrex.Edge.Socket server.
  It is part of the main application supervision tree.
  """

  ############# API ################
  def emit_born(fact) do
    GenServer.cast(
      via(fact.farm.id),
      {:emit_born, fact}
    )
  end

  def child_spec(edge_id) do
    %{
      id: to_name(edge_id),
      start: {__MODULE__, :start_link, [edge_id]},
      restart: :temporary,
      type: :worker
    }
  end

  def start_link(edge_id) do
    res =
      Slipstream.start_link(
        __MODULE__,
        edge_id,
        name: via(edge_id)
      )
    log_res(res)
  end

  ############# CALLBACKS ################
  @impl Slipstream
  def init(edge_id) do
    config = Application.fetch_env!(:agrex_edge, __MODULE__)
    c_res = connect(config)
    case c_res do
      {:ok, socket} ->
        {:ok, socket}

      {:error, reason} ->
        Logger.error(
          "Could not start #{__MODULE__} because of " <>
            "validation failure: #{inspect(reason)}"
        )

        :ignore
    end
  end

  @impl Slipstream
  def handle_connect(socket) do
    Logger.debug("Life.Client connected for #{socket.assigns.edge_id}}")
    {:ok, socket}
  end

  @impl Slipstream
  def handle_info(msg, socket) do
    Logger.debug("Life.Client received: #{inspect(msg)}")
    {:noreply, socket}
  end

  @impl Slipstream
  def handle_cast({:emit_born, fact}, socket) do
    Logger.debug("Life.Client #{socket.assigns.edge_id} emitting born fact: #{inspect(fact)}")
    {:noreply, socket}
  end

  ############# INTERNALS ################
  defp via(edge_id),
    do: Agrex.Registry.via_tuple({:client, to_name(edge_id)})

  defp to_name(edge_id),
    do: "life.client:#{edge_id}"

end
