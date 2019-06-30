defmodule AtomTweaks.Tweaks.Star do
  @moduledoc """
  Represents that a user has marked a tweak as a favorite of theirs.

  The list of tweaks that a user has starred is called their "stars". The list of users that have
  starred a specific tweak is called the tweak's "stargazers".

  ## Fields

  None. This record is used as a many-to-many relationship between users and tweaks.

  ### Associations

  * `user` - The `AtomTweaks.Accounts.User` who starred the tweak
  * `tweak` - The `AtomTweaks.Tweaks.Tweak` that was starred
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Tweaks.Star
  alias AtomTweaks.Tweaks.Tweak

  @type t :: %Star{}

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
