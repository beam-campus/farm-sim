defmodule Agrex.Herd.State do
  use Ecto.Schema
  import Agrex.Limits
  alias Agrex.Schema.Id

  @moduledoc """
  Documentation for `Agrex.Herd.Params`.
  """

  @prefix "herd"

  @primary_key false
  embedded_schema do
    field :id, :string
    field :size, :integer
  end

  def random() do
    %Agrex.Herd.State{
      id: Id.new(@prefix) |> Id.as_string(),
      size: random_nbr_lives()
    }
  end
end