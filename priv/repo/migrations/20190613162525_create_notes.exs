defmodule AtomTweaks.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :detail_url, :string, null: false
      add :description, :text, null: false

      timestamps()
    end
  end
end
