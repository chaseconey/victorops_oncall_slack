defmodule VictoropsOncallSlackTest do
  use ExUnit.Case
  doctest VictoropsOncallSlack

  test "greets the world" do
    assert VictoropsOncallSlack.hello() == :world
  end
end
