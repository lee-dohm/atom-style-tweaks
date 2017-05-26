defmodule AtomStyleTweaks.Repo.Migrations.RenameStylesTable do
  use Ecto.Migration

  def change do
    rename table(:styles), to: table(:tweaks)
  end
end
