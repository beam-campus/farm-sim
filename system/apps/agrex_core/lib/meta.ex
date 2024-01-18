defmodule Agrex.Facts.Meta do
  use Ecto.Schema

  @moduledoc """
  Agrex.Facts.Meta is the module that contains the facts for the Life Subsystem
  """

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:correlation_id, :string)
    field(:causation_id, :string)

    field(
      :causation_type,
      Ecto.Enum,
      values: [:unknown, :command, :event, :hope, :fact],
      default: :unknown
    )

    field(:timestamp, :utc_datetime)
    field(:order, :integer)
  end
end
