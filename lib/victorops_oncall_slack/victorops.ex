defmodule VictoropsOncallSlack.Victorops do
  use HTTPoison.Base

  @moduledoc """
  Uses `HTTPoison.Base` to define a custom http client for the Victor Ops API.
  """

  @base_url "https://api.victorops.com/"
  @base_headers [{"Content-Type", "application/json"}]

  def process_url(action), do: @base_url <> action

  def process_request_headers(headers) do
    auth_headers() ++ @base_headers ++ headers
  end

  def process_response_body(body) do
    case Poison.decode(body) do
      {:ok, response} ->
        response

      {:error, _} ->
        body
    end
  end

  defp auth_headers() do
    id =
      :victorops_oncall_slack
      |> Application.get_env(__MODULE__, [])
      |> Keyword.fetch!(:api_id)

    key =
      :victorops_oncall_slack
      |> Application.get_env(__MODULE__, [])
      |> Keyword.fetch!(:api_key)

    [{"X-VO-Api-Id", id}, {"X-VO-Api-Key", key}]
  end
end
