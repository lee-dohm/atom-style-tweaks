defmodule AtomTweaks.Repo.Migrations.AddForkedFromToTweaks do
  use Ecto.Migration

  def change do
    alter table(:tweaks) do
      add(:parent, references(:tweaks, on_delete: :nothing, type: :binary_id))
    end
  end
end
