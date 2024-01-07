defmodule MilkToAnalyse.CollectMilk.Payload do
  alias Schema.Milking
  use Ecto.Schema

  embedded_schema do
    field :life_id, :string
    field :robot_id, :string
    embeds_one :milking, Milking
  end

end
