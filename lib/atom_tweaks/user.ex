defmodule AtomTweaks.User do
  @moduledoc """
  Represents a user of the application.
  """
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias AtomTweaks.Repo
  alias AtomTweaks.User

  @derive {Phoenix.Param, key: :name}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:avatar_url, :string)
    field(:github_id, :integer)
    field(:name, :string)
    field(:site_admin, :boolean, default: false)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:avatar_url, :github_id, :name, :site_admin])
    |> validate_required([:avatar_url, :github_id, :name, :site_admin])
    |> validate_url(:avatar_url)
    |> unique_constraint(:name)
    |> unique_constraint(:github_id)
  end

  @doc """
  Determines whether the user with the given `name` exists in the database.
  """
  def exists?(name) do
    query = from(u in __MODULE__, select: 1, limit: 1, where: u.name == ^name)

    case Repo.all(query) do
      [1] -> true
      [] -> false
    end
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
