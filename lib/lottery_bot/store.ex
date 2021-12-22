defmodule LotteryBot.Store do
  alias LotteryBot.Model.Number
  alias LotteryBot.{Repo, SearchParams}

  import Ecto.Query

  def insert_number(number, alias \\ nil) do
    with {:ok, number} <- validate_number(number) do
      %{number: number, alias: alias} |> Number.insert_changeset() |> Repo.insert()
    end
  end

  def find_numbers(params) do
    from(number in Number)
    |> SearchParams.search_params(params)
    |> Repo.all()
  end

  def update_number(number, params) do
    number
    |> Number.update_changeset(params)
    |> Repo.update()
  end

  def delete_number(number) do
    case find_numbers(number: number) do
      [number] -> Repo.delete(number)
      _ -> {:error, "Could not find number"}
    end
  end

  ########## Helpers ##########
  defp validate_number(""), do: {:error, "Invalid number"}

  defp validate_number(number) when is_binary(number) do
    if String.length(number) == 5 and valid_number?(number) do
      {:ok, number}
    else
      {:error, "Number length invalid"}
    end
  end

  defp validate_number(_), do: {:error, "Invalid number"}

  defp valid_number?(number) do
    case Integer.parse(number) do
      {_, ""} -> true
      _ -> false
    end
  end
end
