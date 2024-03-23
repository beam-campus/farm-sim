defmodule AgrexEdge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc """
  AgrexEdge.Application is the main application for the Agrex Edge.
  """
  use Application


  @default_edge_id Agrex.Core.constants()[:edge_id]

  def edge_id,
    do: @default_edge_id

  #  @default_map %Agrex.Schema.Vector{
  #   x: 1_000,
  #   y: 1_000,
  #   z: 1
  #  }

  #  @default_region_init %Agrex.Region.InitParams{
  #    id: "belgium",
  #    nbr_of_farms: Agrex.Limits.max_farms()
  #  }



  @impl Application
  def start(_type, _args) do

    landscape_init = AgrexEdge.Landscape.InitParams.default()

    children = [
      # Start Finch
      {Finch, name: Agrex.Finch},
      {AgrexEdge.Client, landscape_init},
      {Agrex.Countries.Cache, name: Agrex.Countries},
      # Start Landscape System
      {AgrexEdge.Landscape.System, AgrexEdge.Landscape.InitParams.default()},
      #  {Agrex.MngHerd.System, Agrex.MngHerd.State.random(@default_edge_id, @default_map)}
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
