defmodule LotteryBot.MessageFormatter do
  alias LotteryBot.Model.Number

  @status_map %{
    0 => "El sorteo no ha comenzado aún. Todos los números aparecerán como no premiados.",
    1 =>
      "El sorteo ha empezado. La lista de números premiados se va cargando poco a poco. Un número premiado podría llegar a tardar unos minutos en aparecer.",
    2 =>
      "El sorteo ha terminado y la lista de números y premios debería ser la correcta aunque, tomada al oído, no podemos estar seguros de ella.",
    3 => "El sorteo ha terminado y existe una lista oficial en PDF.",
    4 =>
      "El sorteo ha terminado y la lista de números y premios está basada en la oficial. De todas formas, recuerda que la única lista oficial es la que publica la ONLAE y deberías comprobar todos tus números contra ella."
  }

  def format_status(status) do
    case @status_map[status] do
      nil -> {"Unknown status #{inspect(status)}", []}
      status -> {status, []}
    end
  end

  def format_number(%Number{} = number) do
    """
    Número: *#{number.number}*
    Alias: _#{number.alias || "-"}_
    Ganador: *#{number.winner}*
    Premio: #{number.price || "-"}
    Consultado: #{maybe_date_to_string(number.last_checked_at)}
    """
  end

  def format_numbers({_, _} = error), do: error
  def format_numbers(numbers), do: {Enum.join(numbers, "\n"), [parse_mode: "Markdown"]}

  #### Helpers ####
  defp maybe_date_to_string(nil), do: "Nunca"
  defp maybe_date_to_string(%DateTime{} = datetime), do: DateTime.to_iso8601(datetime)
end
