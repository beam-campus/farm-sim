defmodule Agrex.Landscape.InitParams do
  @moduledoc """
  Landscape.InitParams is a struct that holds the parameters for initializing a landscape.
  """
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:nbr_of_countries, :integer)
    field(:min_area, :integer)
    field(:min_people, :integer)
    embeds_many(:select_from, :string)
  end

  def default,
    do: europe()

  def europe,
    do: %Agrex.Landscape.InitParams{
      id: "europe",
      edge_id: Agrex.Core.constants()[:edge_id],
      nbr_of_countries: Agrex.Limits.max_regions(),
      min_area: 30_000,
      min_people: 10_000_000,
      select_from: ["Europe"]
    }

  def asia,
    do: %Agrex.Landscape.InitParams{
      id: "asia",
      edge_id: Agrex.Core.constants()[:edge_id],
      nbr_of_countries: Agrex.Limits.max_regions(),
      min_area: 50_000,
      min_people: 40_000_000,
      select_from: ["Asia"]
    }
end
