defmodule LotteryBot.Model.Number do
  use Ecto.Schema

  alias Ecto.Changeset

  schema "numbers" do
    field(:number, :string, null: false)
    field(:alias, :string)
    field(:winner, :boolean)
    field(:price, :string)
    field(:last_checked_at, :utc_datetime)

    timestamps()
  end

  def insert_changeset(params) do
    fields = [:number, :alias]

    %__MODULE__{}
    |> Changeset.cast(params, fields)
    |> Changeset.validate_required([:number])
  end

  def update_changeset(%__MODULE__{} = number, params) do
    fields = [:alias, :winner, :price, :last_checked_at]
    Changeset.cast(number, params, fields)
  end
end
