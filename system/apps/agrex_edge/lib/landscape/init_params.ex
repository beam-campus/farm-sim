defmodule AgrexEdge.Landscape.InitParams do
  @moduledoc """
  Landscape.InitParams is a struct that holds the parameters for initializing a landscape.
  """
  use Ecto.Schema

  require MnemonicSlugs

  @derive {Jason.Encoder,
           only: [:id, :edge_id, :nbr_of_countries, :min_area, :min_people, :select_from]}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:edge_id, :string)
    field(:nbr_of_countries, :integer)
    field(:min_area, :integer)
    field(:min_people, :integer)
    embeds_many(:select_from, :string)
  end

  def default,
    do: europe()

  def europe,
    do: %AgrexEdge.Landscape.InitParams{
      id: "europe",
      name: "Europe",
      edge_id: "europe_" <> Agrex.Schema.Edge.random_id(),
      nbr_of_countries: Agrex.Limits.max_regions(),
      min_area: 30_000,
      min_people: 10_000_000,
      select_from: ["Europe"]
    }

  def asia,
    do: %AgrexEdge.Landscape.InitParams{
      id: "asia",
      name: "Asia",
      edge_id: "asia_" <> Agrex.Schema.Edge.random_id(),
      nbr_of_countries: Agrex.Limits.max_regions(),
      min_area: 50_000,
      min_people: 40_000_000,
      select_from: ["Asia"]
    }

    def from_environment do
      %AgrexEdge.Landscape.InitParams{
        id: System.get_env("LOGATRON_LANDSCAPE_ID"),
        name: System.get_env("LOGATRON_LANDSCAPE_NAME"),
        edge_id: System.get_env("LOGATRON_EDGE_ID"),
        nbr_of_countries: System.get_env("LOGATRON_NBR_OF_COUNTRIES"),
        min_area: System.get_env("LOGATRON_MIN_AREA"),
        min_people: System.get_env("LOGATRON_MIN_PEOPLE"),
        select_from: System.get_env("LOGATRON_SELECT_FROM")
      }
    end

    def from_config do
      %AgrexEdge.Landscape.InitParams{
        id: Application.get_env(:agrex_edge, :landscape_id),
        name: Application.get_env(:agrex_edge, :landscape_name),
        edge_id: Application.get_env(:agrex_edge, :edge_id),
        nbr_of_countries: Application.get_env(:agrex_edge, :nbr_of_countries),
        min_area: Application.get_env(:agrex_edge, :min_area),
        min_people: Application.get_env(:agrex_edge, :min_people),
        select_from: Application.get_env(:agrex_edge, :select_from)
      }
    end

    def from_file do
      {:ok, file} = File.read("landscape_init_params.json")
      {:ok, json} = Jason.decode(file)
      %AgrexEdge.Landscape.InitParams{
        id: Map.get(json, "id"),
        name: Map.get(json, "name"),
        edge_id: Map.get(json, "edge_id"),
        nbr_of_countries: Map.get(json, "nbr_of_countries"),
        min_area: Map.get(json, "min_area"),
        min_people: Map.get(json, "min_people"),
        select_from: Map.get(json, "select_from")
      }
    end

    def from_random do
      %AgrexEdge.Landscape.InitParams{
        id: Agrex.Schema.Landscape.random_id(),
        name: MnemonicSlugs.generate_slug(2),
        edge_id: Agrex.Schema.Edge.random_id(),
        nbr_of_countries: Agrex.Limits.max_regions(),
        min_area: 30_000,
        min_people: 10_000_000,
        select_from: ["Europe"]
      }
    end



end
