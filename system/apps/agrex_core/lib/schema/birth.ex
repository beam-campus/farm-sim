defmodule Agrex.Schema.Birth do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :life_number,
    :born_dead?,
    :survival_code,
    :do_keep?,
    :weight,
    :sex
  ]
  @required_fields [
    :life_number,
    :born_dead?,
    :survival_code,
    :do_keep?,
    :weight,
    :sex
  ]

  embedded_schema do
    field(:life_number, :string)
    field(:born_dead?, :boolean)
    field(:survival_code, :string)
    field(:do_keep?, :boolean)
    field(:weight, :float)
    field(:sex, Ecto.Enum, values: [:unknown, :male, :female])
  end

  def changeset(birth, attrs) do
    birth
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
