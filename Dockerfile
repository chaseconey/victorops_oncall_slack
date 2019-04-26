FROM elixir:1.8-alpine

WORKDIR /var/www/

COPY . .

RUN mix do local.hex --force, local.rebar --force, deps.get --only prod, compile

CMD mix run --no-halt
