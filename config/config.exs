use Mix.Config

config :lottery_bot, LotteryBot.Repo,
  database: "lottery_bot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :lottery_bot,
  ecto_repos: [LotteryBot.Repo]

config :ex_gram,
  token: {:system, "BOT_TOKEN"}

config :logger,
  level: :debug,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :debug}, {LoggerFileBackend, :error}]

config :logger, :debug,
  path: "log/debug.log",
  level: :debug,
  format: "$dateT$timeZ [$level] $message\n"

config :logger, :error,
  path: "log/error.log",
  level: :error,
  format: "$dateT$timeZ [$level] $message\n"
