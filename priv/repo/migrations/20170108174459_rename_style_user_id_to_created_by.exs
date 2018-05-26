defmodule AtomTweaks.Repo.Migrations.RenameStyleUserIdToCreatedBy do
  use Ecto.Migration

  def change do
    alter table(:styles) do
      remove :user_id
      add :created_by, references(:users, on_delete: :nothing, type: :binary_id)
    end
  end
end
