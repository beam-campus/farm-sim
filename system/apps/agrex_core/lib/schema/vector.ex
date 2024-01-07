defmodule Agrex.Schema.Vector do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :x, :integer
    field :y, :integer
    field :z, :integer
  end

  def new(x,y,z) do
    %Agrex.Schema.Vector{
      x: x,
      y: y,
      z: z
    }
  end


  def random(x,y,z) do
    
  end

end
