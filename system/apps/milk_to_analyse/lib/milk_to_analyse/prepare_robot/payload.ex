defmodule MilkToAnalyse.PrepareRobot.Payload do
  use Ecto.Schema

  embedded_schema do
    field :robot_id, :string
  end

end
