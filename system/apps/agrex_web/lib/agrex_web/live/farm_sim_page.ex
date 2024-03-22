defmodule AgrexWeb.FarmSimPage do
  use AgrexWeb, :live_view

  @moduledoc """
  The LandscapeLive is used to broadcast messages to all clients
  """
  require Logger

  @edge_attached_v1 "edge_attached_v1"
  # @edge_region_added_v1 "edge_region_added_v1"

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Agrex.PubSub, @edge_attached_v1)
    {:ok, socket}
  end

  defp assign_landscape_init(socket, landscape_init) do
    Logger.debug("assign_landscape_init: #{inspect(landscape_init)}")
    assign(socket, :landscape_init, landscape_init)
  end

  @impl true
  def handle_info({@edge_attached_v1, landscape_init}, socket),
    do: {:noreply, assign_landscape_init(socket, landscape_init)}

  @impl true
  # attr :landscape_name, :string, default: "unknown"
  def render(assigns) do
    ~H"""
    <div class="h-screen">
      <.live_component module={AgrexWeb.FarmSimTableView} id="farmsim_table_view" />
    </div>
    """
  end

  # handle_event
end
