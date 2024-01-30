defmodule Agrex.Edge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  use Application

  @moduledoc false

  @default_edge_id Agrex.Core.constants()[:edge_id]

  def edge_id,
    do: @default_edge_id

   @default_map %Agrex.Schema.Vector{
    x: 1_000,
    y: 1_000,
    z: 1
   }

  # @default_landscape_params [
  #   name: "farm_scape",
  #   nbr_of_regions: Agrex.Limits.max_regions(),
  #   min_area: 30_000,
  #   min_people: 10_000_000
  # ]


  @impl Application
  def start(_type, _args) do
    children = [
      # Start Finch
      {Finch, name: Agrex.Finch},
      {Agrex.Countries.Cache, name: Agrex.Countries},
      {Agrex.Edge.Client, @default_edge_id},
      # Start Landscape System
      # {Agrex.Landscape.System, @default_landscape_params},
       {Agrex.MngHerd.System, Agrex.MngHerd.State.random(@default_edge_id, @default_map)}
      # {Agrex.Born2Died.System, Agrex.Born2Died.State.random(@default_edge_id, @default_map)}
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
