defmodule Agrex.Edge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  use Application

  @moduledoc false

  @default_edge_id "edge_1"

  @default_landscape_params [
    name: "farm_scape",
    nbr_of_regions: Agrex.Limits.max_regions(),
    min_area: 30_000,
    min_people: 10_000_000
  ]

  # The field is 1_000 x 1_000 meters and labeled 1
  @default_vector Agrex.Schema.Vector.new(1_000, 1_000, 1)

  @impl Application
  def start(_type, _args) do
    children = [
      # Start Finch
      {Finch, name: Agrex.Finch},
      {Agrex.Countries.Cache, name: Agrex.Countries},
      {Agrex.Life.Client, @default_edge_id},
      # Start Landscape System
      # {Agrex.Landscape.System, @default_landscape_params},
      # {Agrex.Herd.System, Agrex.Herd.Params.random()},
      {Agrex.Life.System, Agrex.Life.State.random(@default_edge_id, @default_vector)},
      {Agrex.Life.System, Agrex.Life.State.random(@default_edge_id, @default_vector)},
      {Agrex.Life.System, Agrex.Life.State.random(@default_edge_id, @default_vector)}
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: __MODULE__
    )
  end

  def stop() do
    Supervisor.stop(__MODULE__)
  end
end
