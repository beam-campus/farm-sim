defmodule AgrexWeb.RegionsBrowser do
  use AgrexWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-screen bg-gray-700 p-2 rounded">
      <h2>Regions</h2>
      <div class="overflow-x-auto overflow-y-auto whitespace-nowrap">
        <%= for reg_index <- 1..3 do %>
          <div class="inline-block bg-blue-100 rounded p-2 gap-4">
            <.live_component
              module={AgrexWeb.RegionCard}
              id={"region_#{inspect(reg_index)}"}
              reg_index={reg_index}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
