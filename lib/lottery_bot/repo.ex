defmodule LotteryBot.Repo do
  use Ecto.Repo,
    otp_app: :lottery_bot,
    adapter: Ecto.Adapters.Postgres
end
