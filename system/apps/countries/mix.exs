defmodule Countries.MixProject do
  use Mix.Project

  def project do
    [
      app: :countries,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # ExDoc
      name: "Countries Library",
      source_url: "https://github.com/beam-campus/farm-sim/system/apps/countries",
      homepage_url: "https://discomco.pl",
      docs: [
        main: "Countries Library",
        extras: ["README.md"]
      ]

    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex, :observer]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:jason, "~> 1.3"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: [:dev], runtime: false},
      {:req, "~> 0.4.5"},
      {:typed_struct, "~> 0.3.0"}
    ]
  end
end
