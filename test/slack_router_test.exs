defmodule VictoropsOncallSlack.SlackRouterTest do
  use ExUnit.Case
  use Plug.Test
  use Slash.Test

  import Mox

  alias VictoropsOncallSlack.SlackRouter

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  test "should return help on bad call" do
    conn =
      :post
      |> conn("/", %{})
      |> send_command(SlackRouter, "something")
      |> SlackRouter.call([])

    assert %Plug.Conn{resp_body: body} = conn
    decoded = Jason.decode!(body)

    assert "Slack supports the following commands:" == decoded["text"]
  end

  describe "/victorops oncall <team>" do
    test "oncall requires team" do
      conn =
        :post
        |> conn("/", %{})
        |> send_command(SlackRouter, "oncall")
        |> SlackRouter.call([])

      decoded = Jason.decode!(conn.resp_body)

      assert "Please pass a team name! Find the team by calling `/victorops teams`" ==
               decoded["text"]
    end

    test "test parsing team names" do
      :post
      |> conn("/", %{})
      |> send_command(SlackRouter, "oncall cards-devops")
      |> SlackRouter.call([])

    assert %Plug.Conn{resp_body: body} = conn
    IO.inspect(body)
    end

    # test "something" do
    #   Victorops.MockClient
    #   |> expect(:get, fn url, _headers -> %{body: %{message: "rawr"}} end)

    #   conn =
    #     :post
    #     |> conn("/", %{})
    #     |> send_command(SlackRouter, "oncall team1")
    #     |> SlackRouter.call([])

    #   decoded = Jason.decode!(conn.resp_body)

    #   IO.inspect(decoded)
    # end
  end
end
