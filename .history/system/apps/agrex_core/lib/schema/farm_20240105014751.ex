defmodule Agrex.Schema.Farm do
  use Ecto.Schema
  import Ecto.Changeset

  alias Agrex.Schema.Farm
  alias Agrex.Schema.Id

  @farm_names [
    "Aaron",
    "Abira",
    "Accunti",
    "Adrino",
    "Aldono",
    "Balear",
    "Bandana",
    "Binodo",
    "Castella",
    "Charles",
    "Contina",
    "Cupodo",
    "Dinga",
    "Donga",
    "Datil",
    "Eanti",
    "Elondo",
    "Fildina",
    "Fungus",
    "Fillo",
    "Gerdin",
    "Golles",
    "Hando",
    "Hundi",
    "Impala",
    "Inco",
    "Ilteri",
    "Julo",
    "Jandi",
    "Kold",
    "Kantra",
    "Kilo",
    "Lodi",
    "Lanka",
    "Mista",
    "Nokila",
    "Omki",
    "Pidso",
    "Quenke",
    "Rondi",
    "Solo",
    "Salto",
    "Tandy",
    "Tonko",
    "Telda",
    "Umpo",
    "Uldin",
    "Verto",
    "Wondi",
    "Xunda",
    "Yzum",
    "Zompi"
  ]

  @farm_colors [
    "White",
    "Black",
    "Green",
    "Red",
    "Orange",
    "Yellow",
    "Blue",
    "Indigo",
    "Pink",
    "Brown",
    "Grey",
    "Purple",
    "Cyan",
    "Turquoise"
  ]

  @primary_key false
  embedded_schema do
    field :id, :string
    field :name, :string
    field :nbr_of_robots, :integer
    field :nbr_of_life, :integer
  end

  defp id_prefix, do: "farm"

  def changeset(farm, args) do
    farm
    |> cast(
      args,
      [
        :name,
        :nbr_of_robots,
        :nbr_of_life
      ]
    )
    |> validate_required([
      :name,
      :nbr_of_robots,
      :nbr_of_life
    ])
  end

  def new(attrs) do
    case changeset(%Farm{}, attrs) do
      %{valid?: true} = changeset ->
        id =
          Id.new(id_prefix())
          |> Id.as_string()

        farm =
          changeset
          |> Ecto.Changeset.apply_changes()
          |> Map.put(:id, id)

        {:ok, farm}

      changeset ->
        {:error, changeset}
    end
  end

  def random_name() do
    Enum.random(@farm_colors) <>
      " " <>
      Enum.random(@farm_names) <>
      " " <>
      to_string(:rand.uniform(Agrex.Limits.max_farms()))
  end

  def random do
    %Agrex.Schema.Farm{
      id:
        Agrex.Schema.Id.new(id_prefix())
        |> Id.as_string(),
      name: random_name(),
      nbr_of_life:
        normalize(
          abs(
            :rand.uniform(Agrex.Limits.max_lifes()) -
              :rand.uniform(Agrex.Limits.max_lifes() - Agrex.Limits.min_lifes())
          )
        ),
      nbr_of_robots:
        normalize(
          abs(
            :rand.uniform(Agrex.Limits.max_robots()) -
              :rand.uniform(Agrex.Limits.max_robots() - Agrex.Limits.min_robots())
          )
        )
    }
  end

  defp normalize(res) when res > 0, do: res
  defp normalize(res) when res <= 0, do: 1
end
