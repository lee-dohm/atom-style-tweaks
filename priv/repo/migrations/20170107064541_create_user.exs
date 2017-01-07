defmodule AtomStyleTweaks.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :site_admin, :boolean, default: false, null: false

      timestamps()
    end
    create unique_index(:users, [:name])

  end
end
