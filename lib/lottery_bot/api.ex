defmodule LotteryBot.Api do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.elpais.com/ws/LoteriaNavidadPremiados")

  def status() do
    get!("", query: [s: "1"]).body |> parse_body()
  end

  def summary() do
    get!("", query: [n: "resumen"]).body |> parse_body()
  end

  def check_number(number) do
    number = number |> String.to_integer() |> Integer.to_string()
    get!("", query: [n: number]).body |> parse_body()
  end

  #### Helpers ####
  defp parse_body(body) do
    case String.split(body, "=") do
      [_, rest] -> Jason.decode(rest)
      body -> {:error, "API returned: #{inspect(body)}"}
    end
  end
end
