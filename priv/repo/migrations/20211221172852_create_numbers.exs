defmodule LotteryBot.Repo.Migrations.CreateNumbers do
  use Ecto.Migration

  def change do
    create table(:numbers) do
      add(:number, :text, null: false)
      add(:alias, :text)
      add(:winner, :boolean)
      add(:price, :string)
      add(:last_checked_at, :utc_datetime)

      timestamps()
    end
  end
end
