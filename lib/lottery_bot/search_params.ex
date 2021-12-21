defmodule LotteryBot.SearchParams do
  import Ecto.Query

  def search_params(query, []), do: query

  def search_params(query, [{:number, number} | params]) when is_list(params) do
    query |> where([candle_stick], candle_stick.number == ^number) |> search_params(params)
  end

  def search_params(query, [{:alias, alias} | params]) when is_list(params) do
    query |> where([candle_stick], candle_stick.alias == ^alias) |> search_params(params)
  end

  def search_params(query, [{:winner, true} | params]) when is_list(params) do
    query |> where([candle_stick], candle_stick.winner) |> search_params(params)
  end

  def search_params(query, [{:winner, false} | params]) when is_list(params) do
    query |> where([candle_stick], not candle_stick.winner) |> search_params(params)
  end

  def search_params(query, [{:number_in, numbers} | params]) when is_list(params) do
    query |> where([candle_stick], candle_stick.number in ^numbers) |> search_params(params)
  end

  def search_params(query, [{:limit, limit} | params]) when is_list(params) do
    query |> limit(^limit) |> search_params(params)
  end

  def search_params(query, [_ | params]) when is_list(params) do
    search_params(query, params)
  end
end
