defmodule AgrexWeb.FarmSimTableView do
  use AgrexWeb, :live_component

  @moduledoc """
  The LandscapesLive is used to broadcast messages to all clients
  """


  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-screen">
    <h2>FARMING LANDSCAPES  (connected: <%= @edge_count  %>) </h2>
      <div>
        <div class="flex-grow flex flex-row h-58">
          <.live_component module={AgrexWeb.LandscapesBrowser} id="landscapes_browser" />
        </div>
        <div class="flex-grow flex flex-row h-35">
          <.live_component module={AgrexWeb.RegionsBrowser} id="regions_browser" />
        </div>
        <div class="flex-grow flex flex-row h-30">
          <.live_component module={AgrexWeb.RegionDetail} id="region_detail" />
        </div>
      </div>
    </div>
    """
  end
end
