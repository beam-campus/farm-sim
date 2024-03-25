import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :agrex_web, AgrexWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :agrex_web, Agrex.Repo,
  ecto_repos: [Agrex.Repo],
  generators: [context_app: :agrex]

config :agrex,
  ecto_repos: [Agrex.Repo]

# Configures Swoosh API Client
config :swoosh, :api_client, Agrex.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
