defmodule AtomTweaks.Accounts.User do
  @moduledoc """
  Represents a user of the application.

  ## Fields

  * `avatar_url` - URL of the user's avatar
  * `github_id` - GitHub database ID for the user, unused except to relate the Atom Tweaks member to
    their GitHub user record
  * `name` - Username
  * `site_admin` - `true` if the user is a site admin; `false` otherwise

  ### Associations

  Must be preloaded before they can be used.

  * `stars` - List of `AtomTweaks.Tweaks.Tweak` records the user has starred
  * `tokens` - List of `AtomTweaks.Accounts.Token` records the user has created
  * `tweaks` - List of `AtomTweaks.Tweaks.Tweak` records the user has created or forked
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias AtomTweaks.Accounts.Token
  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Tweaks.Star
  alias AtomTweaks.Tweaks.Tweak

  @type t :: %User{}

  @derive {Phoenix.Param, key: :name}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:avatar_url, :string)
    field(:github_id, :integer)
    field(:name, :string)
    field(:site_admin, :boolean, default: false)

    has_many(:tokens, Token, foreign_key: :user_id)
    has_many(:tweaks, Tweak, foreign_key: :created_by)

    many_to_many(:stars, Tweak, join_through: Star, on_replace: :delete, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:avatar_url, :github_id, :name, :site_admin])
    |> validate_required([:avatar_url, :github_id, :name, :site_admin])
    |> validate_url(:avatar_url)
    |> unique_constraint(:name)
    |> unique_constraint(:github_id)
  end

  defp validate_url(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      case URI.parse(url) do
        %URI{scheme: nil} -> [{:avatar_url, options[:message] || "must be a valid URL"}]
        %URI{host: nil} -> [{:avatar_url, options[:message] || "must be a valid URL"}]
        %URI{path: nil} -> [{:avatar_url, options[:message] || "must be a valid URL"}]
        _ -> []
      end
    end)
  end
end
