defmodule AtomStyleTweaks.Repo.Migrations.AddTypeToTweaks do
  use Ecto.Migration

  def change do
    alter table(:tweaks) do
      add :type, :string, default: "style", null: false
    end
  end
end
