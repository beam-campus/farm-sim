defmodule AgrexWeb.EdgeHandler do
  @moduledoc """
  The EdgeHandler is used to broadcast messages to all clients
  """

  require Logger
  alias Commanded.PubSub
  alias AgrexWeb.ChannelWatcher
  alias Phoenix.PubSub

  @pubsub_edge_detached_v1 "edge_detached_v1"

  def handle_join("edge:lobby", landscape_init, socket) do
    Logger.debug("payload= #{inspect(landscape_init)}")
    send(self(), :after_join)

    :ok =
      ChannelWatcher.monitor(
        "edge:lobby",
        self(),
        {__MODULE__, :leave, [landscape_init]}
      )



    {:ok, socket}
  end

  def leave(landscape_init) do
    Logger.debug("EdgeChannel.leave: leaving edge:lobby #{inspect(landscape_init)}")
    PubSub.broadcast!(Agrex.PubSub, @pubsub_edge_detached_v1 , {@pubsub_edge_detached_v1, landscape_init})
    :ok
  end




end
