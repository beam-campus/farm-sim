defmodule AgrexWeb.FarmSimModel do
  use Ecto.Schema

  @moduledoc """
  The FarmSimModel is used to broadcast messages to all clients
  """

  alias Agrex.Schema.Edge
  alias Agrex.Schema.Landscape

  @primary_key false
  embedded_schema do
    field(:id, :string)
    embeds_many(:edges, Edge)
    embeds_many(:landscapes, Landscape)
  end
end
