defmodule AtomTweaks.Tweaks.Star do
  @moduledoc """
  Represents that a user has marked a tweak as a favorite of theirs.

  The list of tweaks that a user has starred is called their "stars". The list of users that have
  starred a specific tweak is called the tweak's "stargazers".
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias AtomTweaks.Tweaks.Tweak
  alias AtomTweaks.Accounts.User

  schema "stars" do
    belongs_to(:user, User, type: :binary_id)
    belongs_to(:tweak, Tweak, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(star, attrs) do
    star
    |> cast(attrs, [:user_id, :tweak_id])
    |> validate_required([:user_id, :tweak_id])
  end
end
