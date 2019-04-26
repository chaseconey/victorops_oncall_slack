defmodule VictoropsOncallSlack.Cache do
  use GenServer

  require Logger

  alias VictoropsOncallSlack.Client

  # 10 minutes
  @fetch_interval 1_000 * 60 * 10

  # Client

  def get_teams() do
    GenServer.call(__MODULE__, :get_teams)
  end

  def get_team(team) do
    teams = get_teams()

    Enum.find(
      teams,
      fn
        %{"team" => %{"name" => ^team}} -> true
        _ -> false
      end
    )
  end

  def get_phone_for_user(username) do
    GenServer.call(__MODULE__, {:get_phone_for_user, username})
  end

  # Server (callbacks)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :fetch, 0)

    {:ok, %{users: %{}}}
  end

  def handle_info(:fetch, state) do
    state =
      case Client.list_teams() do
        {:ok, %HTTPoison.Response{body: %{"teamsOnCall" => teams}}} ->
          Logger.info("Updating cached teams and on call data.")
          Map.put(state, :teams, teams)

        {:error, _} ->
          state
      end

    Process.send_after(self(), :fetch, @fetch_interval)

    {:noreply, state}
  end

  def handle_call(:get_teams, _, state) do
    {:reply, Map.get(state, :teams, []), state}
  end

  def handle_call({:get_phone_for_user, username}, _, %{users: users} = state) do
    user =
      if user = Map.get(users, username) do
        user
      else
        case Client.get_phone_for_user(username) do
          {:ok, %HTTPoison.Response{body: %{"contactMethods" => phones}}} ->
            Logger.info("Adding user #{username} to cache.")

            [phone | _] = phones

            phone

          {:error, _} ->
            state
        end
      end

    {:reply, user, put_in(state, [:users, username], user)}
  end
end
