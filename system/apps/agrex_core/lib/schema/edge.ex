defmodule Agrex.Schema.Edge do
  use Ecto.Schema

  @moduledoc """
  Agrex.Schema.Edge contains the Ecto schema for the edge.
  """

  import Ecto.Changeset

  alias Agrex.Schema.Edge
  alias Agrex.Schema.Id

  def id_prefix, do: "edge"

  @primary_key false
  embedded_schema do
    field :id, :string
  end

  def random_id() do
    Id.new(id_prefix())
    |> Id.as_string()
  end

  def random() do
    %Edge{
      id: random_id()
    }
  end

  def changeset(edge, args)
      when is_map(args) do
    edge
    |> cast(args, [:id])
    |> validate_required([
      :id
    ])

  end


end
