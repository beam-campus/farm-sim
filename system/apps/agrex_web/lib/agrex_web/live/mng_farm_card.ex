defmodule AgrexWeb.MngFarmCard do
  use AgrexWeb, :live_component

  @moduledoc """
  MngFarmLive  displays the farm management page
  """

  @edge_farm_created_v1 "edge_farm_created_v1"

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-xs rounded overflow-hidden shadow-lg bg-blue-300">
      <div class="px-6 py-4">
        <div class="font-bold text-xl mb-2">Farm <%= @farm_index %></div>
        <div class="text-gray-700 text-base">
          <p>name: Farm_name_<%= @farm_index %> </p>
          <p># of Animals: 10</p>
        </div>
      </div>
    </div>
    """
  end
end
