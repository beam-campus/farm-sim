defmodule Agrex.FarmSupervisor do
  use DynamicSupervisor

  alias Agrex.Schema.Life
  alias Agrex.RobotsSupervisor
  # alias Agrex.Life.Worker
  

  def start_link(sup, [farm: farm] = _opts) do
    IO.puts("FarmSupervisor -> This was received via start_link")
    IO.inspect(sup)
    IO.inspect(farm)

    DynamicSupervisor.start_link(
      __MODULE__,
      farm,
      name: {:global, farm.name}
    )
  end

  @impl true
  def init(opts) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [opts]
    )
  end

  def start_robot(robot) do
    spec = {RobotsSupervisor, robot}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def start_life(%Life{} = life) do
    # spec = {Agrex.Farm.Herd.Life.Worker, life}
    DynamicSupervisor.start_child(
      __MODULE__,
      Agrex.Farm.Herd.Life.Worker.child_spec(life)
    )
  end
end
