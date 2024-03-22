defmodule AgrexWeb.Born2DiedCard do
  use AgrexWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white shadow-md p-4">
      <h2>Born2Died</h2>
      <div class="flex flex-row">
        <div class="w-1/2">
          <h3>Born</h3>
          <div class="flex flex-row">
            <div class="w-1/2">
              Blablabla
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
