defmodule Agrex.Edge.Tui.Application do
  use Application

  def start(_type, _args) do
    children = [
      Agrex.Edge.Tui.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Agrex.Edge.Tui.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
