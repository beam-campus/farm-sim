defmodule AgrexWeb.LifeChannel do
  use AgrexWeb, :channel

  @moduledoc """
  The LifeChannel is used to broadcast messages to all clients
  """


  @impl true
  def join("life:lobby", payload, socket) do
    if authorized?(payload) == false do
      {:error, %{reason: "unauthorized"}}
    else
      {:ok, socket}
    end
  end




  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (life:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    r = :rand.uniform(10)
    case r do
      10 -> false
      _ -> true
    end
  end
end
