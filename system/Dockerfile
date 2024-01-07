################# Variables ################
ARG ELIXIR_VERSION=1.14.0
ARG OTP_VERSION=25.0.3
ARG DEBIAN_VERSION=bullseye-20210902-slim
ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} AS build

ARG SVC_APP=agrex
ARG WEB_APP=agrex_web

# install build essentials
RUN apt-get update -y && apt-get install -y build-essential git nodejs npm curl \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs
# install build dependencies
RUN apk add --no-cache build-base npm git
# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# copy umbrella apps
COPY apps/${SVC_APP} apps/${SVC_APP}
COPY apps/${WEB_APP}/lib apps/${WEB_APP}/priv apps/${WEB_APP}/test apps/${WEB_APP}/mix.exs apps/${WEB_APP}/

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY apps/${WEB_APP}/assets/ ./apps/${WEB_APP}/assets/
# COPY apps/${WEB_APP}/assets/package.json apps/${WEB_APP}/assets/package-lock.json ./apps/${WEB_APP}/assets/
RUN npm --prefix ./apps/${WEB_APP}/assets ci --progress=false --no-audit --loglevel=error

COPY apps/${WEB_APP}/priv apps/${WEB_APP}/assets apps/${WEB_APP}/assets/
RUN npm run --prefix ./apps/${WEB_APP}/assets deploy
RUN mix phx.digest

# compile and build release
COPY . .
RUN mix do compile, release


########### RUNTIME ###############
# prepare release image
FROM alpine:3.9 AS app

ARG SVC_APP=agrex
ARG WEB_APP=agrex_web


RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/${WEB_APP} ./

ENV HOME=/app

CMD ["bin/${WEB_APP}", "start"]

################ Build Step  ###############
# FROM ${BUILDER_IMAGE} as builder
# # install build dependencies
# RUN apt-get update -y && apt-get install -y build-essential git nodejs npm curl \
#   && apt-get clean && rm -f /var/lib/apt/lists/*_*
# RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
#   && apt-get install -y nodejs
# # prepare build dir
# WORKDIR /app

# # install hex + rebar
# RUN mix local.hex --force && \
#   mix local.rebar --force
# # set build ENV
# ENV MIX_ENV="prod"
# # install mix dependencies
# COPY mix.exs mix.lock ./
# RUN mix deps.get --only $MIX_ENV
# RUN mkdir config
# # copy compile-time config files before we compile dependencies

# # to ensure any relevant config change will trigger the dependencies
# # to be re-compiled.
# COPY config/config.exs config/${MIX_ENV}.exs config/
# RUN mix deps.compile
# COPY priv priv
# COPY lib lib
# COPY assets assets
# WORKDIR assets
# RUN node --version
# RUN npm i -g yarn; yarn set version stable
# RUN yarn install
# WORKDIR ../
# # compile assets
# RUN mix assets.deploy
# # Compile the release
# RUN mix compile

# # Changes to config/runtime.exs don't require recompiling the code
# COPY config/runtime.exs config/
# COPY rel rel
# RUN mix release
