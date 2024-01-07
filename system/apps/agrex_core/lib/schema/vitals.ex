defmodule Agrex.Schema.Vitals do
  use Ecto.Schema

  import Agrex.Limits

  @primary_key false
  embedded_schema do
    field :age, :integer
    field :weight, :integer
    field :energy, :integer
    field :is_pregnant, :boolean
    field :heath, :integer
    field :health, :integer
  end

  def random() do
    %Agrex.Schema.Vitals{
      age: random_age(),
      weight: random_weight(),
      energy: random_100(),
      heath: random_100(),
      health: random_100(),
      is_pregnant: false
    }
  end


  defimpl String.Chars, for: Agrex.Schema.Vitals  do
    def to_string(s) do
      "\n\t - vitals -" <>
      "\n\t\t age: #{s.age} \t\t weight: #{s.weight} \t\t energy: #{s.energy}" <>
      "\n\t\t pregnant?: #{s.is_pregnant} \t\t heath: #{s.heath} \t\t health: #{s.health}\n\n"
    end
  end


end
