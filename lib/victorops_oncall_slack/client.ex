defmodule VictoropsOncallSlack.Client do
  # Responsible for pulling stuff from VO

  # @client Victorops.Client
  @client :victorops_oncall_slack
          |> Application.get_env(__MODULE__, [])
          |> Keyword.get(:client, VictoropsOncallSlack.Victorops)

  def list_teams() do
    # Returns list of teams and the current on call info
    @client.get("api-public/v1/oncall/current")
  end

  def get_phone_for_user(username) do
    # Get user contact info from username
    @client.get("api-public/v1/user/#{username}/contact-methods/phones")
  end
end
