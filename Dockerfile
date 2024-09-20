# Build stage
FROM hexpm/elixir:1.17.3-erlang-25.3.2.14-alpine-3.20.3 AS build

# Install build dependencies
RUN apk add --no-cache build-base git

# Prepare build dir
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build ENV
ENV MIX_ENV=prod

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy config files
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

# Copy app files
COPY priv priv
COPY lib lib

# Compile and build release
RUN mix do compile, release

# Start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM alpine:3.20.3 AS app
RUN apk add --no-cache openssl libstdc++

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/gakimint ./

ENV HOME=/app

CMD ["bin/gakimint", "start"]