defmodule AtomTweaks.Repo.Migrations.AddGithubIdToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :github_id, :integer
    end

    create unique_index(:users, [:github_id])
  end
end
