defmodule Agrex.Schema.Robot do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Agrex.Schema.Robot contains the Ecto schema for a Robbot
  """
  alias Agrex.Schema.{
    Life,
    Robot,
    Id
  }

  defmodule Schema.Robot.Status do
    defmodule Schema.Robot.Status do
  end
    @type t :: robot_status_enum()

    @spec unknown() :: t
    def unknown(), do: :unknown

    @spec inactive() :: t
    def inactive(), do: :inactive

    @spec active() :: t
    def active(), do: :active

    @spec idle() :: t
    def idle(), do: :idle

    @spec milking() :: t
    def milking(), do: :milking

    @spec cleaning() :: t
    def cleaning(), do: :cleaning

    @spec to_string(t) :: String.t()
    def to_string(status),
      do: to_string(robot_status_enum(), status)

    @spec to_string(robot_status_enum(), t) :: String.t()
    def to_string(enum, status),
      do: to_string(enum, status, :unknown)

    @spec to_string(robot_status_enum(), t, atom()) :: String.t()
    def to_string(enum, status, default) when is_atom(default),
      do: to_string(enum, status, Atom.to_string(default))

    @spec to_string(robot_status_enum(), t, String.t()) :: String.t()
    def to_string(enum, status, default) when is_binary(default),
      do: to_string(enum, status, default, [])

    @spec to_string(robot_status_enum(), t, String.t(), Keyword.t()) :: String.t()
    def to_string(enum, status, default, options) when is_binary(default) and is_list(options),
      do: to_string(enum, status, default, options, [])

    @spec to_string(robot_status_enum(), t, String.t(), Keyword.t(), String.t()) :: String.t()
    def to_string(enum, status, default, options, prefix) when is_binary(default) and is_list(options) and is_binary(prefix),
      do: to_string(enum, status, default, options, prefix, [])

    @spec to_string(robot_status_enum(), t, String.t(), Keyword.t(), String.t(), String.t()) :: String.t()
    def to_string(enum, status, default, options, prefix, suffix) when is_binary(default) and is_list(options) and is_binary(prefix) and is_binary(suffix),
      do: to_string(enum, status, default, options, prefix, suffix, [])

    @spec to_string(robot_status_enum(), t, String.t(), Keyword.t(), String.t(), String.t(),
  end

  @type robot_status_enum :: :unknown | :inactive | :active | :idle | :milking | :cleaning
  def robot_status_enum(),
    do: %{
      unknown: 0,
      inactive: 1,
      active: 2,
      idle: 4,
      milking: 8,
      cleaning: 16
    }

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:stable_id, :string)
    field(:name, :string)
    field(:status, :integer)
  end

  @fields [:id, :name, :status, :stable_id]
  @required_fields [:id, :name, :status, :stable_id]

  defp id_prefix, do: "robot"

  def start_milking(%Robot{} = robot, %Life{} = life) do
    case changeset(robot, %{
           status: Status.milking()
         }) do
      %{valid?: true} = changeset ->
        new_robot =
          changeset
          |> Ecto.Changeset.apply_changes()

        {:ok, new_robot}

      changeset ->
        {:error, changeset}
    end
  end

  def changeset(%Robot{} = robot, %{} = attrs) do
    robot
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  def new(name) when is_bitstring(name) do
    defaults = %{name: name, status: Status.unknown()}
    new(defaults)
  end

  def new(%{} = attrs) when is_map(attrs) do
    case changeset(%Robot{id: Id.new(id_prefix())}, attrs) do
      %{valid?: true} = changeset ->
        robot =
          changeset
          |> Ecto.Changeset.apply_changes()

        {:ok, robot}

      changeset ->
        {:error, changeset}
    end
  end
end
