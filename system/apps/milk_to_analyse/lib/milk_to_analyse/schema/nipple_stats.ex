defmodule MilkToAnalyse.Schema.NippleStats do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :milk_time, :integer
    field :dead_milk_time, :integer
    field :conductivity, :integer
    field :color_code, :string
    field :scc, :integer
  end

  def changeset(stats, args) do
    stats
    |> cast(args, [
      :milk_time,
      :dead_milk_time,
      :conductivity,
      :color_code,
      :scc
    ])
    |> validate_required([
      :milk_time,
      :dead_milk_time,
      :conductivity,
      :color_code,
      :scc
    ])
  end
end
