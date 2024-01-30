defmodule Agrex.Schema.Life do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Agrex.Schema.Life is the module that contains the Ecto data definition
  for a ver
  """
  alias Agrex.Schema.{
    Id,
    Life,
    LifeNames
  }

  @genders [
    "male",
    "female"
  ]

  @primary_key false
  embedded_schema do
    field :id, :string
    field :name, :string
    field :gender, :string
    field :birth_date, :date
    field :father_id, :string
    field :mother_id, :string
  end

  @fields [
    :id,
    :name,
    :gender,
    :birth_date,
    :father_id,
    :mother_id
  ]

  def id_prefix, do: "life"

  def changeset(life, attr) do
    life
    |> cast(attr, @fields)
    |> validate_required([:gender])
  end

  def new(%{} = attr) when is_map(attr) do
    id = Id.new(id_prefix()) |> Id.as_string()

    case changeset(%Life{id: id}, attr) do
      %{valid?: true} = changeset ->
        life =
          changeset
          |> Ecto.Changeset.apply_changes()

        {:ok, life}

      changeset ->
        {:error, changeset}
    end
  end

  def new() do
    %Life{
      id: random_life_id()
    }
  end

  def random_life_id,
    do:
      Id.new(id_prefix())
      |> Id.as_string()

  def random do
    gender = Enum.random(@genders)
    %Life{
      id: random_life_id(),
      name: LifeNames.random_name(gender),
      gender: gender,
      birth_date: NaiveDateTime.utc_now(),
      father_id: "unknown",
      mother_id: "unknown"
    }
  end

  def new_birth(father_id, mother_id) do
    gender = Enum.random(@genders)
    %Life{
      id: random_life_id(),
      name: LifeNames.random_name(gender),
      gender: gender,
      birth_date: NaiveDateTime.utc_now(),
      father_id: father_id,
      mother_id: mother_id
    }
  end

  defimpl String.Chars, for: Agrex.Schema.Life  do
    def to_string(s) do
      "\n\n [Life]" <>
      "\n\t id: \t #{s.id} \t name: \t #{s.name}" <>
      "\n\t f_id: \t #{s.father_id} \t m_id: \t #{s.mother_id}" <>
      "\n\t gender: \t #{s.gender} \t dob: \t #{s.birth_date}"
    end
  end


end
