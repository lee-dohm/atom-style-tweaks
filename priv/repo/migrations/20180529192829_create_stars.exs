defmodule AtomTweaks.Repo.Migrations.CreateStars do
  use Ecto.Migration

  def change do
    create table(:stars) do
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :tweak_id, references(:tweaks, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:stars, [:user_id, :tweak_id])
  end
end
