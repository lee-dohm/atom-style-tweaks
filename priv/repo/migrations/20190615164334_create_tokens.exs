defmodule AtomTweaks.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :scopes, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:tokens, [:user_id])
  end
end
