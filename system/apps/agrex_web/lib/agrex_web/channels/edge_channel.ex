defmodule AgrexWeb.EdgeChannel do
  use AgrexWeb, :channel

  @moduledoc """
  The FarmChannel is used to broadcast messages to all clients
  """

  @fact_born "fact:born"
  @fact_died "fact:died"
  @hope_shout "hope:shout"
  @hope_ping "hope:ping"

  require Logger


  ################ CALLBACKS ################
  @impl true
  def join("edge:lobby", _payload, socket) do
    Logger.debug("EdgeChannel.join: #{inspect(socket)}")
    {:ok, socket}
  end

    # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(@hope_ping, payload, socket) do
    {:reply, {:ok, payload}, socket}
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
    {:ok, socket}
  end

  @impl true
  def handle_in(@fact_died, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@fact_died} #{inspect(payload)}")
    topic = to_topic(payload["edge_id"])
    Phoenix.PubSub.broadcast(Agrex.PubSub, topic, @fact_died, payload)
    {:ok, socket}
  end

  ################ INTERNALS ################
  defp to_topic(edge_id),
    do: "life:lobby:#{edge_id}"
end
