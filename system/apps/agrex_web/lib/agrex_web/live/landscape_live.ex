defmodule AgrexWeb.LandscapeLive do
  use AgrexWeb, :live_view

  def mount(_params, _session, socket) do
    new_socket = assign(socket, name: "FarmTrax", nbr_of_farms: 3)
    inspect(new_socket)
    {:ok, new_socket}
  end

  # render
  def render(assigns) do
    ~L"""
    <h1>Agrex Landscape</h1>
    <div id="landscape">
      <div class="landscape-form">
        <span>name: <%= @name %></span>
        <span>number of farms: <%= @nbr_of_farms %></span>
      </div>
    </div>
    """
  end

  # handle_event
end
