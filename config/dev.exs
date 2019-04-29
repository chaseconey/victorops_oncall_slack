use Mix.Config

config :slash, VictoropsOncallSlack.SlackRouter, signing_key: System.get_env("SIGNING_KEY")

config :victorops_oncall_slack, VictoropsOncallSlack.Victorops,
  api_id: System.get_env("VO_API_ID"),
  api_key: System.get_env("VO_API_KEY")
