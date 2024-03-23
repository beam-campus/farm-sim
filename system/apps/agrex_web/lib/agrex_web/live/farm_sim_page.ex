defmodule AgrexWeb.FarmSimPage do
  use AgrexWeb, :live_view

  @moduledoc """
  The LandscapeLive is used to broadcast messages to all clients
  """
  require Logger

  @edge_attached_v1 "edge_attached_v1"
  @landscape_attached_v1 AgrexWeb.Facts.landscape_attached_v1()
  # @edge_region_added_v1 "edge_region_added_v1"

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Agrex.PubSub, @edge_attached_v1)
    Phoenix.PubSub.subscribe(Agrex.PubSub, @landscape_attached_v1)
    {:ok, socket}
  end

  defp assign_landscape_init(socket, landscape_init) do
    Logger.debug("assign_landscape_init: #{inspect(landscape_init)}")
    assign(socket, :landscape_init, landscape_init)
  end

  defp increase_edge_count(socket) do
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

  @impl true
  def handle_info({@edge_attached_v1, _landscape_init}, socket),
    do: {:noreply, increase_edge_count(socket)}

  @impl true
  def handle_info({@landscape_attached_v1, landscape_init}, socket),
    do: {:noreply, assign_landscape_init(socket, landscape_init)}

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
