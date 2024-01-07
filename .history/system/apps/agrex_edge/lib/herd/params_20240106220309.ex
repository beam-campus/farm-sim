defmodule Agrex.Herd.Params do
  use Ecto.Schema
  import Agrex.Limits
  alias Agrex.Schema.Id

  @prefix "herde"

  @primary_key false
  embedded_schema do
    field :herd_id, :string
    field :size, :integer
  end

  def random() do
    %Agrex.Herd.Params{
      herd_id: Id.new(@prefix) |> Id.as_string(),
      size: random_nbr_lies()
    }
  end
end
