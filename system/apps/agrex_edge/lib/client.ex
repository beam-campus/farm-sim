defmodule Agrex.Edge.Client do
  use Slipstream

  require Logger

  @moduledoc """
  Agrex.Edge.Client is the client-side of the Agrex.Edge.Socket server.
  It is part of the main application supervision tree.
  """

  ############# API ################

  ############# CALLBACKS ################
  @impl Slipstream
  def init(config) do
    {:ok, connect!(config), {:continue, {:start_ping, config[:edge_id]}}}
  end

  @impl Slipstream
  def handle_connect(socket) do
    Logger.debug("Edge.Client connected for #{inspect(socket)}")
    {:ok, join(socket, to_topic(socket.assigns.edge_id))}
  end

  @impl Slipstream
  def handle_join("edge:lobby", _payload, socket) do
    Logger.debug("Edge.Client.handle_join: #{inspect(socket)}")
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

  @impl Slipstream
  def handle_cast({:emit_born, edge_id, fact}, socket) do
    Logger.debug("Edge.Client #{inspect(socket)}")
    topic = to_topic(edge_id)
    res = await_join(socket, topic, fact)
    Logger.debug("Edge.Client await_join #{inspect(res)}")
    push(socket, topic, "fact:born", fact)
    {:noreply, socket}
    # Logger.debug("Edge.Client #{socket.assigns.edge_id} emitting born fact: #{inspect(fact)}")
    # {:noreply, socket}
  end

  # @impl Slipstream
  # def handle_cast({:join_edge, edge_id}, socket) do
  #   Logger.debug("Edge.Client #{inspect(socket)}")
  #   res = Slipstream.await_join(socket, "life:lobby:#{edge_id}")
  #   Logger.debug("Edge.Client await_join #{inspect(res)}")
  #   {:noreply, socket}
  #   # Logger.debug("Edge.Client #{socket.assigns.edge_id} emitting born fact: #{inspect(fact)}")
  #   # {:noreply, socket}
  # end

  @impl Slipstream
  def handle_cast({:emit_died, edge_id, fact}, socket) do
    Logger.debug("Edge.Client #{inspect(socket)}")
    topic = to_topic(edge_id)
    push(socket, topic, "fact:died", fact)
    {:noreply, socket}
    # Slipstream.await_message(^topic, "fact:died", ^fact)
    # {:noreply, socket}
    # Logger.debug("Edge.Client #{socket.assigns.edge_id} emitting born fact: #{inspect(fact)}")
    # {:noreply, socket}
  end

  @impl Slipstream
  def handle_call({:join_edge, edge_id}, _from, socket) do
    socket = assign(socket, :edge_id, edge_id)
    Logger.debug("Edge.Client #{inspect(socket)}")
    res = await_join(socket, "edge:lobby")
    Logger.debug("Edge.Client await_join #{inspect(res)} #{inspect(socket)})}")
    {:reply, res, socket}
    # Logger.debug("Edge.Client #{socket.assigns.edge_id} emitting born fact: #{inspect(fact)}")
    # {:noreply, socket}
  end

  @impl Slipstream
  def handle_call({:emit_born, edge_id, fact}, _from, socket) do
    Logger.debug("Edge.Client #{inspect(socket)}")
    topic = to_topic(edge_id)
    res = await_message(^topic, "fact:born", ^fact)
    Logger.debug("Edge.Client await_message #{inspect(res)}")
    {:reply, res, socket}
    # Logger.debug("Edge.Client #{socket.assigns.edge_id} emitting born fact: #{inspect(fact)}")
    # {:noreply, socket}
  end

  @impl Slipstream
  def handle_call({:emit_died, edge_id, fact}, _from, socket) do
    Logger.debug("Edge.Client #{inspect(socket)}")
    topic = to_topic(edge_id)
    res = Slipstream.await_message(^topic, "fact:died", ^fact)
    Logger.debug("Edge.Client await_message #{inspect(res)}")
    {:reply, res, socket}
    # Logger.debug("Edge.Client #{socket.assigns.edge_id} emitting born fact: #{inspect(fact)}")
    # {:noreply, socket}
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
    config = Keyword.put(config, :edge_id, edge_id)
    %{
      id: to_name(edge_id),
      start: {__MODULE__, :start_link, [config]},
      restart: :transient,
      type: :worker
    }
  end

  def start_link(edge_id, config),
    do:
      Slipstream.start_link(
        __MODULE__,
        config,
        name: via(edge_id)
      )
end
