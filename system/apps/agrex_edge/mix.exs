defmodule AgrexEdge.MixProject do
  use Mix.Project

  def project do
    [
      app: :agrex_edge,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # ExDoc
      name: "FarmSim Edge",
      source_url: "https://github.com/discomco-ex/farm-sim",
      homepage_url: "https://discomco.pl",
      docs: [
        main: "Agrex Edge",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Agrex.Edge.Application, []},
      extra_applications: [:logger, :runtime_tools, :observer, :eex, :wx]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:slipstream, "~>1.1.0"},
      {:agrex_core, in_umbrella: true}
    ]
  end
end
