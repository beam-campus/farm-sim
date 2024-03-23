defmodule AgrexWeb.EdgeChannel do
  use AgrexWeb, :channel

  @moduledoc """
  The EdgeChannel is used to broadcast messages to all clients
  """

  @fact_born "fact:born"
  @fact_died "fact:died"
  @hope_shout "hope:shout"
  @hope_ping "ping"
  @hope_join_edge "join_edge"
  @edge_attached_v1 "edge:attached:v1"
  @pubsub_attached_v1 "edge_attached_v1"

  @attach_landscape_v1 "attach_landscape:v1"

  require Logger
  require Phoenix.PubSub
  require AgrexEdge.Facts

  ################ CALLBACKS ################
  @impl true
  def join("edge:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("hello", payload, socket) do
    Logger.debug("in: 'hello' #{inspect(payload)}")
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in(@edge_attached_v1, landscape_init, socket) do
    Logger.debug(
      "EdgeChannel.handle_in: #{@edge_attached_v1}. Publishing #{inspect(landscape_init)} to #{@pubsub_attached_v1}"
    )

    Phoenix.PubSub.broadcast!(
      Agrex.PubSub,
      @pubsub_attached_v1,
      {@pubsub_attached_v1, landscape_init}
    )

    {:reply, {:ok, landscape_init}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(@hope_ping, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@hope_ping} #{inspect(payload)}")
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in(@hope_join_edge, payload, socket) do
    broadcast(socket, @hope_shout, payload)
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (farm:lobby).
  @impl true
  def handle_in(@hope_shout, payload, socket) do
    broadcast(socket, @hope_shout, payload)
    {:noreply, socket}
  end

  # We might want to use GenStage, GenFlow or Broadway at a later moment,
  # instead of publishing it on PubSub (should PubSub be a bottleneck).
  @impl true
  def handle_in(@fact_born, payload, socket) do
    Logger.debug("EdgeChannel.handle_in (#{inspect(@fact_born)}): #{inspect(payload)}")
    topic = to_topic(payload["edge_id"])
    Phoenix.PubSub.broadcast(Agrex.PubSub, topic, @fact_born, payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in(@fact_died, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@fact_died} #{inspect(payload)}")
    topic = to_topic(payload["edge_id"])
    Phoenix.PubSub.broadcast(Agrex.PubSub, topic, @fact_died, payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in(@attach_landscape_v1, landscape_init, socket),
    do: AgrexWeb.LandscapeHandler.attach_landscape_v1(landscape_init, socket)

  ################ INTERNALS ################
  defp to_topic(edge_id),
    do: "edge:lobby:#{edge_id}"
end
