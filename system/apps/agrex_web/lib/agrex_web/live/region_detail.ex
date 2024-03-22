defmodule AgrexWeb.RegionDetail do
  use AgrexWeb, :live_component

  @moduledoc """
  RegionDetail  displays the region details page
  """

  def render(assigns) do
    ~H"""
    <div class="w-screen bg-gray-700 h-200">
      <h2>REGION DETAILS for Poland</h2>
      <div class="flex flex-row">
        <div class="w-1/3 overflow-y-auto">
          <!-- Adjust width as needed -->
          <.live_component module={AgrexWeb.MngFarmBrowser} id="mng_farm_browser" />
        </div>
        <div class="flex-grow" overflow-y-auto overflow-x-auto>
          <!-- This will occupy the remaining width -->
          <.live_component module={AgrexWeb.Born2DiedBrowser} id="born2died_browser" } />
        </div>
      </div>
    </div>
    """
  end
end
