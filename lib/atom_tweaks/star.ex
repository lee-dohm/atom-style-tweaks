defmodule AtomTweaks.Star do
  @moduledoc """
  Represents that a user has marked a tweak as a favorite of theirs.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias AtomTweaks.Tweak
  alias AtomTweaks.User

  schema "stars" do
    belongs_to :user, User
    belongs_to :tweak, Tweak

    timestamps()
  end

  @doc false
  def changeset(star, attrs) do
    star
    |> cast(attrs, [:user_id, :tweak_id])
    |> validate_required([:user_id, :tweak_id])
  end
end
