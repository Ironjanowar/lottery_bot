defmodule LotteryBot.Bot do
  @bot :lottery_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Muestra la ayuda")
  command("add", description: "/add <number> <alias>")
  command("remove", description: "/remove <number>")
  command("status", description: "Consulta el estado del sorteo")
  command("check", description: "/check [number:<number>] [alias:<alias>]")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help:")
  end

  def handle({:command, :add, %{text: text}}, context) do
    {message, options} = LotteryBot.add_number(text)
    answer(context, message, options)
  end

  def handle({:command, :remove, %{text: text}}, context) do
    {message, options} = LotteryBot.remove_number(text)
    answer(context, message, options)
  end

  def handle({:command, :status, _msg}, context) do
    {message, options} = LotteryBot.status()
    answer(context, message, options)
  end

  def handle({:command, :check, %{text: text}}, context) do
    {message, options} = LotteryBot.check_numbers(text)
    answer(context, message, options)
  end
end
