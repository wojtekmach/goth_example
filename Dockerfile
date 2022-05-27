FROM hexpm/elixir:1.13.4-erlang-25.0-alpine-3.15.4 as build

# install build dependencies
RUN apk add --no-cache --update git build-base

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build project
COPY lib lib
RUN mix compile

# build release
COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.15.4 AS app
RUN apk add --no-cache --update bash openssl libstdc++

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/goth_example ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["/app/bin/goth_example", "start_iex"]
