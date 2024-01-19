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
  def publish(edge_id, event, payload) do
    GenServer.cast(
      via(edge_id),
      {:publish, @edge_lobby, event, payload}
    )
  end


  ############# CALLBACKS ################
  @impl Slipstream
  def handle_cast({:publish, topic, event, payload}, socket) do
    socket
    |> push(topic, event, payload)
    {:noreply, socket}
  end


  @impl Slipstream
  def init(args) do
    socket =
      new_socket()
      |> assign(:edge_id, args.edge_id)
      |> connect!(args.config)
    {:ok, socket, {:continue, :start_ping}}
  end

  @impl Slipstream
  def handle_connect(socket) do
    {:ok, join(socket, @edge_lobby, %{edge_id: socket.assigns.edge_id})}
  end

  @impl Slipstream
  def handle_join(@edge_lobby, _join_response, socket) do
    push(socket, @edge_lobby, "edge:attached:v1", %{edge_id: socket.assigns.edge_id})
    {:ok, socket}
  end

  @impl Slipstream
  def handle_disconnect(_reason, socket) do
    {:stop, :normal, socket}
  end

  @impl Slipstream
  def handle_continue(:start_ping, socket) do
    {:noreply, socket}
  end

  @impl Slipstream
  def handle_info(msg, socket) do
    Logger.debug("Edge.Client received: #{inspect(msg)}")
    {:noreply, socket}
  end


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
      start: {__MODULE__, :start_link, [%{config: config, edge_id: edge_id}]},
      restart: :transient,
      type: :worker
    }
  end

  def start_link(args),
    do:
      Slipstream.start_link(
        __MODULE__,
        args,
        name: via(args.edge_id)
      )
end
