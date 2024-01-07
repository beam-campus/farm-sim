defmodule MilkToAnalyse.ReleaseLife.Payload do
  use Ecto.Schema

  embedded_schema do
    field :life_id, :string
    field :robot_id, :string
  end

end
