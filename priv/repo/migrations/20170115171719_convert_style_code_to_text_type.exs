defmodule AtomTweaks.Repo.Migrations.ConvertStyleCodeToTextType do
  use Ecto.Migration

  def change do
    alter table(:styles) do
      modify(:code, :text)
    end
  end
end
