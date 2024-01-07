defmodule Agrex.Schema.Calving do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Agrex.Schema.Birth contains the Ecto schema for births of calves.
  """
  alias Agrex.Schema.Calving
  alias Agrex.Schema.Id

  embedded_schema do
    field :mother_life_number, :string
    field :father_life_number, :string
    field :calving_date, :date
    field :remarks, :string
    field :dryoff_date, :date
    field :lac_number, :integer
  end

  def id_prefix, do: "calving"

  def changeset(calving, attrs) do
    calving
    |> cast(
      attrs,
      [
        :mother_life_number,
        :father_life_number,
        :calving_date,
        :remarks,
        :dryoff_date,
        :lac_number
      ]
    )
    |> validate_required([
      :mother_life_number,
      :father_life_number,
      :calving_date,
      :lac_number
    ])
  end

  def new(attrs) do
    case changeset(%Calving{}, attrs) do
      %{valid?: true} = changeset ->
        calving =
          changeset
          |> Ecto.Changeset.apply_changes()
          |> Map.put(:id, Id.new(id_prefix()))

        {:ok, calving}

      changeset ->
        {:error, changeset}
    end
  end
end
