defmodule AtomTweaks.Accounts.Token do
  @moduledoc """
  Represents a user access token for authenticating against the API.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias AtomTweaks.Accounts.User

  @valid_scopes [
    "release_notes/write"
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tokens" do
    field(:description, :string)
    field(:scopes, {:array, :string})

    belongs_to(:user, User, foreign_key: :user_id, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:description, :scopes, :user_id])
    |> validate_required([:description, :scopes, :user_id])
    |> validate_length(:scopes, min: 1)
    |> validate_subset(:scopes, @valid_scopes)
  end
end
