defmodule Agrex.Edge.Client do
  use Slipstream

  require Logger

  @moduledoc """
  Agrex.Edge.Client is the client-side of the Agrex.Edge.Socket server.
  It is part of the main application supervision tree.
  """

  @edge_lobby "edge:lobby"
  # @joined_edge_lobby "edge:lobby:joined"

  ############# API ################

  ############# CALLBACKS ################
  @impl Slipstream
  def init(config) do
    Logger.debug("in:config #{inspect(config)}")
    {:ok, connect!(config), {:continue, :start_ping}}
  end

  @impl Slipstream
  def handle_connect(socket) do
    Logger.debug("Edge.Client connected for #{inspect(socket)}")
    {:ok, join(socket, @edge_lobby)}
  end

  @impl Slipstream
  def handle_join(@edge_lobby, _join_response, socket) do
    push(socket, @edge_lobby, "hello", %{})
    {:ok, socket}
  end

  @impl Slipstream
  def handle_disconnect(_reason, socket) do
    {:stop, :normal, socket}
  end

  @impl Slipstream
  def handle_continue(:start_ping, socket) do
    Logger.debug("Edge.Client.handle_continue: #{inspect(socket)}")
    {:noreply, socket}
  end

  @impl Slipstream
  def handle_info(msg, socket) do
    Logger.debug("Edge.Client received: #{inspect(msg)}")
    {:noreply, socket}
  end


  ############# INTERNALS ################

  ############ PLUMBING ################
  def to_name(edge_id),
    do: "edge.client:#{edge_id}"

  def to_topic(edge_id),
    do: "edge:lobby:#{edge_id}"

  def via(edge_id),
    do: Agrex.Registry.via_tuple({:client, to_name(edge_id)})

  def child_spec(edge_id) do
    config = Application.fetch_env!(:agrex_edge, __MODULE__)
    %{
      id: to_name(edge_id),
      start: {__MODULE__, :start_link, [config, edge_id]},
      restart: :transient,
      type: :worker
    }
  end

  def start_link(config, edge_id),
    do:
      Slipstream.start_link(
        __MODULE__,
        config,
        name: via(edge_id)
      )
end
