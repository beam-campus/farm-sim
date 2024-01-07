defmodule MilkToAnalyse.State do
  use Ecto.Schema
  import Ecto.Changeset

  alias Schema.Life
  alias Schema.Robot
  alias Schema.Milking
  alias Schema.Id

  @primary_key false
  embedded_schema do
    embeds_one :id, Id
    embeds_one :life, Life
    embeds_one :robot, Robot
    embeds_one :milking, Milking
  end

  def id_prefix, do: "milk-to-analyze"

  def changset(state, args) do
    state
    |> cast(args, [])
    |> cast_embed(:id, with: &Id.changeset/2)
    |> cast_embed(:life, with: &Life.changeset/2)
    |> cast_embed(:robot, with: &Robot.changeset/2)
    |> cast_embed(:milking, with: &Milking.changeset/2)
  end

  def new(args \\ %{status: MilkToAnalyse.Status.unknown()}) do
    case changset(%MilkToAnalyse.State{}, args) do
      %{valid?: true} = changeset ->
        state =
          changeset
          |> apply_changes()
          |> Map.put(:id, Id.new(id_prefix()))

        {:ok, state}

      changeset ->
        {:error, changeset}
    end
  end
end
