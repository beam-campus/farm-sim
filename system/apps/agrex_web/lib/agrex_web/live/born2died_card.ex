defmodule AgrexWeb.Born2DiedCard do
  use AgrexWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-green-300 shadow-md rounded">
      <div class="px-2 py-2">
        <div class="font-bold text-xl mb-2">Life <%= @life_index %></div>
        <div class="text-gray-700 text-base">
          <p>name: Bella the Cow</p>
          <p>age: 3</p>
          <p>health: 35</p>
        </div>
      </div>
    </div>
    """
  end
end
