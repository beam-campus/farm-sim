defmodule Agrex.Schema.BloodLine do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Agrex.Schema.BloodLine contains the Ecto schema definition for a BloodLine
  """
  alias Agrex.Schema.BloodLine
  alias Agrex.Schema.Id

  embedded_schema do
    field :life_number,       :string
    field :blood_type_code,   :string
    field :percentage,        :float
  end

  def id_prefix, do: "bloodline"

  def changeset(bloodline, attrs) do
    bloodline
    |> cast(attrs,
            [
              :life_number,
              :blood_type_code,
              :percentage
            ])
    |> validate_required(
        [
          :life_number,
          :blood_type_code,
          :percentage
        ])
  end

  def new(attrs) do

    case changeset(%BloodLine{}, attrs) do

      %{valid?: true} = changeset ->
        bloodline =
          changeset
          |> Ecto.Changeset.apply_changes()
          |> Map.put(:id, Id.new(id_prefix()))
        {:ok, bloodline}

      changeset ->
        {:error, changeset}

    end
  end



end
