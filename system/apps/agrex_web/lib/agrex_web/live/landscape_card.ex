defmodule AgrexWeb.LandscapeCard do
  use AgrexWeb, :live_component


  attr :ls_index, :integer, default: 1
  @impl true
  def render(assigns) do
    ~H"""
      <div class="max-w-xs rounded overflow-hidden shadow-lg bg-blue-300">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2"> Landscape <%= @ls_index %> </div>
          <div class="text-gray-700 text-base">
            <p>name: landscape_456</p>
            <p># of Countries: 3</p>
            <p>min. Area: 100 sq. km</p>
            <p>min. People: 5M</p>
            <p>From: Europe</p>
          </div>
        </div>
      </div>
    """
  end
end
