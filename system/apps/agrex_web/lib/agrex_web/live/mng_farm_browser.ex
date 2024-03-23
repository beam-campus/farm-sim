defmodule AgrexWeb.MngFarmBrowser do
  use AgrexWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex flex-col bg-gray-400 p-2 rounded">
      <h2>Farms</h2>
      <div class="flex flex-col overflow-x-auto overflow-y-auto whitespace-nowrap">
        <%= for farm_index <- 1..3 do %>
          <div class="inline-block bg-blue-100 rounded p-2 gap-4">
            <.live_component
              module={AgrexWeb.MngFarmCard}
              id={"mng_farm_#{inspect(farm_index)}"}
              farm_index={farm_index}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
