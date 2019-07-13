defmodule AtomTweaks.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:key, :string)
      add(:value, :map)

      timestamps()
    end
  end
end
