defmodule Agrex.Life.Facts.Ate do
  use Ecto.Schema

  @moduledoc """
  Agrex.Life.Facts.Ate is the module that contains the facts for the Life Subsystem
  """

  @primary_key false
  embedded_schema do
    field :meta 
  end


end
