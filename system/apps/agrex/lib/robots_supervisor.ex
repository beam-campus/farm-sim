defmodule Agrex.RobotsSupervisor do
  use DynamicSupervisor

  @moduledoc """
  The RobotsSupervisor is a dynamic supervisor that allows us
  to add robots to a farm
  """

  alias Agrex.RobotWorker

  def start_link(sup, _opts \\ []) do
    DynamicSupervisor.start_link(
      __MODULE__,
      sup,
      name: __MODULE__
    )
  end

  @impl true
  def init(robots) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [robots]
    )
  end

  def start_child(robot) do
    spec = {RobotWorker, %{robot: robot}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
