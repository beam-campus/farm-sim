defmodule AgrexWeb.Born2DiedBrowser do
  use AgrexWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col flex-grow bg-gray-400 p-2 rounded">
      <h2>Born2Died</h2>
      <div class="flex flex-wrap whitespace-nowrap">
        <%= for life_index <- 1..3 do %>
          <div class="inline-block bg-blue-100 rounded p-2 gap-4">
            <.live_component
              module={AgrexWeb.Born2DiedCard}
              id={"born2died_#{inspect(life_index)}"}
              life_index={life_index}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end

end
