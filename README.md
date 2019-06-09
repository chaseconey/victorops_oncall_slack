# VictoropsOncallSlack

[![CircleCI](https://circleci.com/gh/chaseconey/victorops_oncall_slack.svg?style=svg)](https://circleci.com/gh/chaseconey/victorops_oncall_slack)

## Todo

- [ ] Add a real search to `oncall` command (rather than straight comparison)

## Installation

- `touch config/dev.secret.ecs`
- Add in env vars like so:

```
use Mix.Config

config :victorops_oncall_slack, VictoropsOncallSlack.Victorops,
  api_id: "your-id",
  api_key: "your-key"
```

- `mix deps.get`
- `mix run --no-halt`
