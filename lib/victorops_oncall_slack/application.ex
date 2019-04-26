defmodule VictoropsOncallSlack.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = System.get_env("PORT") || "8080"

    port =
      port
      |> Integer.parse()
      |> case do
        {int, ""} -> int
        :error -> 8080
      end

    children = [
      VictoropsOncallSlack.Cache,
      {Plug.Cowboy, scheme: :http, plug: VictoropsOncallSlack.Router, options: [port: port]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VictoropsOncallSlack.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
