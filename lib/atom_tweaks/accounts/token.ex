defmodule AtomTweaks.Accounts.Token do
  @moduledoc """
  Represents a user access token for authenticating against the API.

  ## Fields

  * `description` - Text description for remembering what the token is used for
  * `scopes` - Array of access rights that control what the token is used to access

  ### Associations

  Must be preloaded before they can be used.

  * `user` - The `AtomTweaks.Accounts.User` who created the token
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

  @doc false
  def salt, do: Application.get_env(:atom_tweaks, __MODULE__)[:salt]

  @doc """
  Generates the token code from the given `token`.
  """
  def to_code(token = %__MODULE__{}) do
    Phoenix.Token.sign(AtomTweaksWeb.Endpoint, salt(), token.id, max_age: :infinity)
  end
end
