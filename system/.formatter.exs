[
  inputs: [
    "*.{heex,ex,exs}",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "priv/*/seeds.exs",
    "mix.exs",
    "config/*.exs"
  ],
  subdirectories: [
    "apps/*",
    "priv/*/migrations"
  ],
  import_deps: [:ecto, :phoenix],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  line_length: 80
]
