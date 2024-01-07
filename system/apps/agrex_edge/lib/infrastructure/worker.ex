defmodule Agrex.Farm.Infra.Robot.Worker do
  use GenServer

  @self __MODULE__

  alias Agrex.FarmRegistry

  alias Agrex.Schema.{
    Robot
  }

  alias Agrex.Facts.{
    MilkingStarted
  }

  require Logger

  # Client
  def start_link(
        _init_arg,
        %Robot{id: id, name: name} = robot
      ) do
    Logger.info("Starting Robot [#{name}]")

    GenServer.start_link(
      @self,
      robot,
      name: Farm.Registry.register_via(id)
    )
  end

  def start_milking(life) do
    GenServer.cast(__MODULE__, {:start_milking, life})
  end

  # Server
  @impl true
  def init(robot) do
    Phoenix.PubSub.subscribe(Agrex.PubSub, Agrex.Topics.pulsed())
    {:ok, robot}
  end

  @impl true
  def handle_cast({:start_milking, life}, robot) do
    case Robot.start_milking(robot, life) do
      {:ok, new_robot} ->
        Phoenix.PubSub.broadcast!(
          Agrex.PubSub,
          MilkingStarted.topic_v1(),
          MilkingStarted.new(%{
            robot: new_robot,
            life: life
          })
        )

        {:noreply, new_robot}

      _ ->
        {:noreply, robot}
    end
  end
end
