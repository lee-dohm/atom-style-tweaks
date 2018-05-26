defmodule AtomTweaks.Repo.Migrations.AddDescriptionToTweaks do
  use Ecto.Migration

  def change do
    alter table(:tweaks) do
      add :description, :text
    end
  end
end
