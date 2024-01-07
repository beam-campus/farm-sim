defp deps do
  [
    {:uuid, "~> 1.1"},
    {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
    {:erlex, "~> 0.2.6", only: [:dev, :test], runtime: false},
    {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
    {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
  ]
end
