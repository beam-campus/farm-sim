defmodule AgrexWeb.RegionCard do
  use AgrexWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-xs rounded overflow-hidden shadow-lg bg-blue-300">
      <div class="px-2 py-2">
        <div class="font-bold text-xl mb-2">Country <%= @reg_index %></div>
        <div class="text-gray-700 text-base">
          <p>name: Poland</p>
          <p># of Farms: 3</p>
        </div>
      </div>
    </div>
    """
  end
end
