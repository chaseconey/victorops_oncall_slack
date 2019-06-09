defmodule VictoropsOncallSlack.SlackRouter do
  use Slash.Builder

  alias VictoropsOncallSlack.Cache

  # /victorops oncall <team>
  # /victorops teams

  # command(:async_greet, fn command ->
  #   async(command, fn ->
  #     Process.sleep(5_000)

  #     "Async response!"
  #   end)
  # end)

  @help """
  Lists all teams in Victorops

  Example: '/victorops teams'
  """
  command(:teams, fn _command ->
    case Cache.get_teams() do
      teams = [_ | _] ->
        attachments =
          Enum.map(teams, fn %{"team" => team, "oncallNow" => oncall} ->
            format_team(team, oncall)
          end)
          |> Enum.take(100)

        %{attachments: attachments, text: "Teams and their respective on call team members."}

      _ ->
        "Problem loading teams..."
    end
  end)

  @help """
  Lists a team's current on call members and their contact details.

  Example: '/victorops oncall Cards-Dash'
  """
  command(:oncall, fn %{args: args} ->
    team = Enum.join(args, " ")

    case Cache.get_team(team) do
      %{"team" => team, "oncallNow" => oncall} ->
        attachment = format_team(team, oncall, true)

        %{attachments: [attachment]}

      _ ->
        "Problem loading team..."
    end
  end)

  defp format_team(team, oncall, pull_phones \\ false) do
    %{
      fallback: "List of teams and on call team members",
      color: "#36a64f",
      title: team["name"],
      text: team["slug"],
      fields: format_users(oncall, pull_phones)
    }
  end

  defp format_users(oncall, pull_phones) do
    oncall
    |> Enum.reduce([], fn policy, acc ->
      Enum.map(policy["users"], fn user ->
        username = user["onCalluser"]["username"]

        user = %{
          title: username,
          short: true
        }

        user =
          if pull_phones do
            phone = Cache.get_phone_for_user(username)

            Map.put(user, :value, phone["value"])
          end

        user
      end) ++ acc
    end)
    |> Enum.uniq()
  end
end
