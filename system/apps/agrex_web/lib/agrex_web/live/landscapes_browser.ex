defmodule AgrexWeb.LandscapesBrowser do
  use AgrexWeb, :live_component

  @impl true
  def update(assigns, socket) do
    new_socket =
      socket
      # |> assign(assigns)
      |> assign(:no_landscapes, 1)

    {:ok, new_socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-screen bg-gray-700 rounded p-2">
      <h2>Landscapes</h2>
      <div class="overflow-x-auto overflow-y-auto whitespace-nowrap">
        <%= for ls_index <- 1..@no_landscapes do %>
          <div class="inline-block bg-blue-100 rounded p-2 gap-4">
            <.live_component
              module={AgrexWeb.LandscapeCard}
              id={"landscape_#{inspect(ls_index)}"}
              ls_index={ls_index}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # @impl true
  # def render(assigns) do
  #   ~H"""
  #   <div id="LsCa" phx-hook="LandscapesCarousel">
  #     <div class="swiper-container">
  #       <div class="swiper-wrapper whitespace-nowrap">
  #         <%= for ls_index <- 1..@no_landscapes do %>
  #           <div class="swiper-slide bg-blue-100 rounded p-2 gap-4">
  #             <.live_component
  #               module={AgrexWeb.LandscapeCard}
  #               id={"landscape_#{inspect(ls_index)}"}
  #               ls_index={ls_index}
  #             />
  #           </div>
  #         <% end %>
  #       </div>
  #       <!-- Add pagination bullets if needed -->
  #       <div class="swiper-pagination"></div>
  #       <div class="swiper-button-prev"></div>
  #       <div class="swiper-button-next"></div>
  #     </div>
  #   </div>
  #   """
  # end
end
