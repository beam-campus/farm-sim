defmodule Agrex.Edge.Client do
  use Slipstream

  require Logger

  @moduledoc """
  Agrex.Edge.Client is the client-side of the Agrex.Edge.Socket server.
  It is part of the main application supervision tree.
  """

  ############ PLUMBING ################
  def child_spec(edge_id),
    do: %{
      id: to_name(edge_id),
      start: {__MODULE__, :start_link, [edge_id]},
      restart: :transient,
      type: :worker
    }

  def start_link(edge_id) do
    res =
      Slipstream.start_link(
        __MODULE__,
        edge_id,
        name: via(edge_id)
      )

    Logger.info("Agrex.Edge.Client.start_link/1: #{inspect(res)}")
  end

  ############# API ################
  def await_register(edge_id),
    do:
      GenServer.call(
        via(edge_id),
        {:join, edge_id}
      )

  def emit_born(edge_id, fact) do
    GenServer.cast(
      via(edge_id),
      {:emit_born, edge_id, fact}
    )
  end

  def emit_died(edge_id, fact),
    do:
      GenServer.cast(
        via(edge_id),
        {:emit_died, edge_id, fact}
      )

  def await_emit_born(edge_id, fact),
    do:
      GenServer.call(
        via(edge_id),
        {:emit_born, edge_id, fact}
      )

  def await_emit_died(edge_id, fact),
    do:
      GenServer.call(
        via(edge_id),
        {:emit_died, edge_id, fact}
      )

  ############# CALLBACKS ################
  @impl Slipstream
  def init(edge_id) do
    config = Application.fetch_env!(:agrex_edge, __MODULE__)
    c_res = connect(config)

    case c_res do
      {:ok, socket} ->
        # Logger.debug("Edge.Client connected for #{edge_id} socket: #{inspect(socket)}")
        {:ok, assign(socket, :edge_id, edge_id)}

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
    Logger.debug("Edge.Client connected for #{inspect(socket)}")
    {:ok, socket}
    # Logger.debug("Edge.Client connected for #{socket.assigns.edge_id}}")
    # {:ok, socket}
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

  @impl Slipstream
  def handle_cast({:join, edge_id}, socket) do
    Logger.debug("Edge.Client #{inspect(socket)}")
    res = Slipstream.await_join(socket, "life:lobby:#{edge_id}")
    Logger.debug("Edge.Client await_join #{inspect(res)}")
    {:noreply, socket}
    # Logger.debug("Edge.Client #{socket.assigns.edge_id} emitting born fact: #{inspect(fact)}")
    # {:noreply, socket}
  end

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
  def handle_call({:join, edge_id}, _from, socket) do
    Logger.debug("Edge.Client #{inspect(socket)}")
    res = await_join(socket, "life:lobby:#{edge_id}")
    Logger.debug("Edge.Client await_join #{inspect(res)}")
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

  defp to_name(edge_id),
    do: "edge.client:#{edge_id}"

  defp to_topic(edge_id),
    do: "life:lobby:#{edge_id}"

  defp via(edge_id),
    do: Agrex.Registry.via_tuple({:client, to_name(edge_id)})
end
