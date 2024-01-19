defmodule Agrex.Core.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  use Application

  @moduledoc false

  @impl Application
  def start(_type, _args) do
    children = [
      # Start the Registry
      {Agrex.Registry, name: Agrex.Registry},
      # Start the PubSub system
      {Phoenix.PubSub, name: Agrex.PubSub},
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
