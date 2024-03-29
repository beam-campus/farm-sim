defmodule AgrexWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :agrex_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AgrexWeb.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :observer,
        :os_mon
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.11", override: true},
      {:phoenix_ecto, "~> 4.5.1"},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, ">= 0.0.0"},
      {:floki, ">= 0.36.1" },
      {:phoenix_html, "~> 4.1.1"},
      {:phoenix_live_reload, "~> 1.5.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.14"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      # {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      # {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:esbuild, "~> 0.7"},
      {:tailwind, "~> 0.2.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:agrex, in_umbrella: true},
      {:plug_cowboy, "~> 2.5"},
      {:contex, "~> 0.5.0"},
      {:heroicons, "~> 0.5.5"},
      {:heroicons_liveview, "~> 0.5.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
