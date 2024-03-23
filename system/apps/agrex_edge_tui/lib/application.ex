defmodule AgrexEdge.Tui.Application do
  use Application

  def start(_type, _args) do
    children = [
      AgrexEdge.Tui.Supervisor
    ]

    opts = [strategy: :one_for_one, name: AgrexEdge.Tui.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
