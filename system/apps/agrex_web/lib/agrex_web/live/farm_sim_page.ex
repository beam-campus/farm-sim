defmodule AgrexWeb.FarmSimPage do
  use AgrexWeb, :live_view

  @moduledoc """
  The LandscapeLive is used to broadcast messages to all clients
  """
  require Logger
  alias AgrexCore.Facts

  @edge_attached_v1 Facts.edge_attached_v1()
  @edge_detached_v1 Facts.edge_detached_v1()
  # @landscape_attached_v1 Facts.landscape_attached_v1()
  # @edge_region_added_v1 "edge_region_added_v1"

  ################# INTERNALS ################

  ###################### API ######################
  def add_edge(socket, landscape_init) do
    socket
    |> increase_edge_count(landscape_init)
    |> assign_landscape_init(landscape_init)
  end

  defp increase_edge_count(socket, _landscape_init) do
    if Map.has_key?(socket.assigns, :edge_count) do
      Logger.debug("increase_edge_count: #{inspect(socket.assigns.edge_count)}")

      socket
      |> assign(:edge_count, socket.assigns.edge_count + 1)
    else
      Logger.debug("increase_edge_count: no edge_count, setting to 1")

      socket
      |> assign(:edge_count, 1)
    end
  end

  defp assign_landscape_init(socket, landscape_init) do
    Logger.debug("assign_landscape_init: #{inspect(landscape_init)}")
    assign(socket, :landscape_init, landscape_init)
  end

  def drop_edge(socket, landscape_init) do
    Logger.debug("FarmSimPageDispatcher.decrease_edge: #{inspect(landscape_init)}")

    socket
    |> decrease_edge_count(landscape_init)
    |> assign_landscape_init(landscape_init)
  end

  defp decrease_edge_count(socket, _landscape_init) do
    if Map.has_key?(socket.assigns, :edge_count) do
      Logger.debug("decrease_edge_count: #{inspect(socket.assigns.edge_count)}")

      socket
      |> assign(:edge_count, socket.assigns.edge_count - 1)
    else
      Logger.debug("decrease_edge_count: no edge_count, setting to 0")

      socket
      |> assign(:edge_count, 0)
    end
  end

  ################# CALLBACKS #################
  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Agrex.PubSub, @edge_attached_v1)
    Phoenix.PubSub.subscribe(Agrex.PubSub, @edge_detached_v1)
    # Phoenix.PubSub.subscribe(Agrex.PubSub, @landscape_attached_v1)
    {:ok, socket}
  end

  @impl true
  def handle_info({@edge_attached_v1, landscape_init}, socket),
    do: {:noreply, add_edge(socket, landscape_init)}

  @impl true
  def handle_info({@edge_detached_v1, landscape_init}, socket),
    do: {:noreply, drop_edge(socket, landscape_init)}

  # @impl true
  # def handle_info({@landscape_attached_v1, landscape_init}, socket),
  #   do: {:noreply, assign_landscape_init(socket, landscape_init)}

  # defp assign_landscape_init(socket, landscape_init) do
  #   Logger.debug("assign_landscape_init: #{inspect(landscape_init)}")
  #   assign(socket, :landscape_init, landscape_init)
  # end

  @impl true
  # attr :landscape_name, :string, default: "unknown"
  attr :edge_count, :integer, default: 0

  def render(assigns) do
    ~H"""
    <div class="w-full">
      <.live_component
        module={AgrexWeb.FarmSimTableView}
        id="farmsim_table_view"
        edge_count={@edge_count}
      />
    </div>
    """
  end

  # handle_event
end
