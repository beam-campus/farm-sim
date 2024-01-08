defmodule Agrex.Life.BornFact do
  use Ecto.Schema

  alias Agrex.Schema.Life
  alias Agrex.Schema.Id

  @moduledoc """
  Life.BornFact is a fact that is emitted when a new Life is born.
  """
  @id_prefix "born"

  @primary_key false
  embedded_schema do
    field :id, :string
    field :farm_id, :string
    field :life_id, :string
    field :born_at, :naive_datetime
  end


  def new(farm_id, %Life{} = life) do
    %__MODULE__{
      id: Id.new(@id_prefix) |> Id.as_string,
      farm_id: farm_id,
      life_id: life.id,
      born_at: life.birth_date
    }
  end





end
