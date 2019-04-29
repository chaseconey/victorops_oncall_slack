FROM elixir:1.8-alpine

WORKDIR /var/www/

ENV MIX_ENV prod

COPY . .

RUN mix do local.hex --force, local.rebar --force, deps.get --only prod, compile

CMD mix run --no-halt
