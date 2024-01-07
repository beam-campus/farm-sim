defmodule Agrex.Life.Aggregate do
  use GenServer


  @self __MODULE__

  def start_link(life) do
    GenServer.start_link(
      @self,
      life,
      name: do_via_tuple(life.id) )
  end

  defp do_via_tuple(life_id) do
    Agrex.Life.Registry.via_tuple({@self, life_id})
  end

  @impl true
  def init(life) do
    {:ok,
     %{
       state: life,
       events: []
     }}
  end
end
