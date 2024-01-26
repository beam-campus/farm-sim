defmodule Agrex.Schema.Vector do
  use Ecto.Schema

  @moduledoc """
  Agrex.Schema.Vector is the module that contains the vector schema
  """

  @primary_key false
  embedded_schema do
    field :x, :integer
    field :y, :integer
    field :z, :integer
  end

  def new(x, y, z) do
    %Agrex.Schema.Vector{
      x: x,
      y: y,
      z: z
    }
  end


  def random(max_x, max_y, max_z) do
    x = :rand.uniform(max_x)
    y = :rand.uniform(max_y)
    z = :rand.uniform(max_z)
    new(x, y, z)
  end

end
