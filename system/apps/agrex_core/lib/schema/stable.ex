defmodule Agrex.Schema.Stable do
  use Ecto.Schema

  schema "stables" do
    belongs_to :farm, Agrex.Schema.Farm
    has_many :robots, Agrex.Schema.Robot
  end
end
