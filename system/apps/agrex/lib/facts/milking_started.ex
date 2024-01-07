defmodule Agrex.Facts.MilkingStarted do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  MilkingStarted is a fact that is emitted by a RobotWorker
  when a Life arrives at a Robot and attaches itself to it.
  """

  alias Agrex.Schema.Id
  alias Agrex.Facts.MilkingStarted
  alias Agrex.Facts.MilkingStarted.Payload

  def topic_v1, do: "agrex:milking_started:v1"

  embedded_schema do
    embeds_one :payload, Payload
    timestamps()
  end

  defp id_prefix, do: "milking-started"

  def changeset(fact, args) do
    fact
    |> cast(args, [])
    |> cast_embed(
      :payload,
      required: true,
      with: &Payload.changeset/2
    )
  end

  def new(args) do
    case changeset(%MilkingStarted{}, args) do
      %{valid?: true} = changeset ->
        fact =
          changeset
          |> Ecto.Changeset.apply_changes()
          |> Map.put(:id, Id.new(id_prefix()))
          |> Map.put(:inserted_at, DateTime.utc_now())

        {:ok, fact}

      changeset ->
        {:error, changeset}
    end
  end

  defmodule Payload do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      embeds_one :robot, Agrex.Schema.Robot
      embeds_one :life, Agrex.Schema.Life
    end

    def changeset(payload, args) do
      payload
      |> cast(args, [])
      |> cast_embed(:robot,
        required: true,
        with: &Agrex.Schema.Robot.changeset/2
      )
      |> cast_embed(:life,
        required: true,
        with: &Agrex.Schema.Life.changeset/2
      )
    end

    def new(args) when is_map(args) do
      case changeset(%Payload{}, args) do
        %{valid?: true} = changeset ->
          payload =
            changeset
            |> Ecto.Changeset.apply_changes()

          {:ok, payload}

        changeset ->
          {:error, changeset}
      end
    end
  end
end
