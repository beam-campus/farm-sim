defmodule Agrex.Region.InitParams do
  @moduledoc """
  Agrex.Region.State is the struct that identifies the state of a Region.
  """

  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:nbr_of_farms, :integer)
  end

  def random(id) do
    %Agrex.Region.InitParams{
      id: id,
      nbr_of_farms: :rand.uniform(5)
    }
  end

  def default,
    do: %Agrex.Region.InitParams{
      id: "belgium",
      nbr_of_farms: 3
    }

end
