defmodule AtomTweaks.Repo.Migrations.CreateStyle do
  use Ecto.Migration

  def change do
    create table(:styles, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:title, :string)
      add(:code, :string)
      add(:user_id, references(:users, on_delete: :nothing, type: :binary_id))

      timestamps()
    end

    create(index(:styles, [:user_id]))
  end
end
