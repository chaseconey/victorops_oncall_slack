defmodule VictoropsOncallSlack.Router do
  use Plug.Router

  # NOTE: The custom body_reader option here is critical.
  plug(
    Plug.Parsers,
    parsers: [:urlencoded],
    body_reader: {Slash.BodyReader, :read_body, []}
  )

  plug(:match)
  plug(:dispatch)

  forward("/slack", to: VictoropsOncallSlack.SlackRouter)

  get "/health" do
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "")
  end
end
