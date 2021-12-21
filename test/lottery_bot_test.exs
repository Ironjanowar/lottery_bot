defmodule LotteryBotTest do
  use ExUnit.Case
  doctest LotteryBot

  test "greets the world" do
    assert LotteryBot.hello() == :world
  end
end
