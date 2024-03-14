defmodule Agrex.MngFarm.InitParams do
  @moduledoc """
  Agrex.MngFarm.InitParams is the struct that identifies the state of a Farm.
  """
  use Ecto.Schema

  @id_prefix "mng_farm"

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:nbr_of_lives, :integer)
    embeds_one(:farm, Agrex.Schema.Farm)
  end

  def default,
    do: %Agrex.MngFarm.InitParams{
      id: "mng_farm-0000-0000-0000-000000000000",
      nbr_of_lives: 10
    }

  def random(farm),
    do: %Agrex.MngFarm.InitParams{
      id: Agrex.Schema.Id.new(@id_prefix) |> Agrex.Schema.Id.as_string(),
      nbr_of_lives: Agrex.Limits.random_nbr_lives(),
      farm: farm
    }
end
