defmodule LotteryBot do
  require Logger

  alias LotteryBot.{Api, MessageFormatter, Store}
  alias LotteryBot.Model.Number

  def add_number(text) do
    with {:ok, %{number: number, alias: alias}} <- parse_text(text),
         {:ok, number} <- Store.insert_number(number, alias) do
      {"Number #{number.number} added", []}
    else
      {:error, error} ->
        {error, []}

      error ->
        error |> inspect |> Logger.error()
        {"There was an error", []}
    end
  end

  def remove_number(text) do
    case Store.delete_number(text) do
      {:ok, number} ->
        {"Number #{number.number} removed", []}

      {:error, error} ->
        {error, []}

      error ->
        error |> inspect |> Logger.error()
        {"There was an error", []}
    end
  end

  def status() do
    case Api.status() do
      {:ok, %{"status" => status}} -> MessageFormatter.format_status(status)
      _ -> {:error, "Could not get status"}
    end
  end

  def check_numbers(text) when is_binary(text) do
    text
    |> parse_search_params()
    |> Store.find_numbers()
    |> check_numbers()
    |> MessageFormatter.format_numbers()
  end

  def check_numbers([]), do: {"No numbers found", []}

  def check_numbers([%Number{} | _] = numbers) do
    Enum.map(numbers, fn number ->
      number.number
      |> Api.check_number()
      |> maybe_update_number(number)
      |> MessageFormatter.format_number()
    end)
  end

  #### Helpers ####
  defp parse_text(text) do
    text |> String.split(" ") |> get_number_and_alias()
  end

  defp get_number_and_alias([number, alias]), do: {:ok, %{number: number, alias: alias}}
  defp get_number_and_alias([number]), do: {:ok, %{number: number, alias: nil}}
  defp get_number_and_alias(_), do: {:ok, "Invalid input"}

  defp parse_search_params(""), do: []

  defp parse_search_params(text) do
    text |> String.split(" ") |> Enum.map(&to_search_param/1) |> Enum.reject(&is_nil/1)
  end

  defp to_search_param("number:" <> number), do: {:number, number}
  defp to_search_param("n:" <> number), do: {:number, number}
  defp to_search_param("alias:" <> alias), do: {:alias, alias}
  defp to_search_param("a:" <> alias), do: {:alias, alias}
  defp to_search_param("winner:true"), do: {:winner, true}
  defp to_search_param("winner:false"), do: {:winner, false}
  defp to_search_param("w:true"), do: {:winner, true}
  defp to_search_param("w:false"), do: {:winner, false}
  defp to_search_param(_), do: nil

  defp maybe_update_number({:ok, result}, number) do
    price = maybe_translate(result["premio"])
    winner = winner_from_price(result["premio"])

    params = %{price: price, winner: winner, last_checked_at: now()}

    case Store.update_number(number, params) do
      {:ok, number} ->
        number

      error ->
        log_error(number, error)
        number
    end
  end

  defp maybe_update_number(error, number) do
    log_error(number, error)
    number
  end

  defp log_error(number, error) do
    Logger.error("Could not update number #{number.number}, error: #{inspect(error)}")
  end

  defp maybe_translate(0), do: "NO premiado"
  defp maybe_translate(ok), do: ok

  defp winner_from_price(0), do: false
  defp winner_from_price(_), do: true

  defp now() do
    DateTime.utc_now() |> DateTime.add(3600)
  end
end
