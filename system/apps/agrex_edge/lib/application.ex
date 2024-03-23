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

  @impl Application
  def start(_type, _args) do

    landscape_init = AgrexEdge.Landscape.InitParams.europe()
    children = [
      {Finch, name: Agrex.Finch},
      {AgrexEdge.Client, landscape_init},
      {Agrex.Countries.Cache, name: Agrex.Countries},
      {AgrexEdge.Landscape.System, landscape_init}
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
