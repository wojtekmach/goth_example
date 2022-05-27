FROM elixir as build

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
FROM elixir AS app

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/goth_example ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD ["/app/bin/goth_example", "start_iex"]
