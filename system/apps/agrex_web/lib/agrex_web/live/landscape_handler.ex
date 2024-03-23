defmodule AgrexWeb.LandscapeHandler do
  @moduledoc """
  The LandscapeHandler is used to broadcast messages to all clients
  """

  alias AgrexCore.Facts

  require Logger

  @pubsub_landscape_attached_v1 Facts.landscape_attached_v1()

  def attach_landscape_v1(landscape_init, socket) do
    Logger.debug("#{inspect(landscape_init)}")

    Phoenix.PubSub.broadcast(
      Agrex.PubSub,
      @pubsub_landscape_attached_v1,
      {@pubsub_landscape_attached_v1, landscape_init}
    )

    {:noreply, socket}
  end
end
