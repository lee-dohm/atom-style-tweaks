defmodule AtomTweaks.Accounts do
  @moduledoc """
  Context for handling accounts and their operations.
  """
  import Ecto.Query, warn: false

  alias Ecto.Changeset

  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Repo

  @doc """
  Creates an `Ecto.Changeset` for tracking user changes.
  """
  @spec change_user(User.t()) :: Changeset.t()
  def change_user(user = %User{}) do
    User.changeset(user, %{})
  end

  @doc """
  Gets a user by name.

  Returns `nil` if no user by that name exists.
  """
  @spec get_user(String.t()) :: User.t() | nil
  def get_user(name) do
    Repo.get_by(User, name: name)
  end

  @doc """
  Gets a user by name.

  Raises `Ecto.NoResultsError` if no user by that name exists.
  """
  @spec get_user!(String.t()) :: User.t() | no_return
  def get_user!(name) do
    Repo.get_by!(User, name: name)
  end

  @doc """
  Lists all users in the database.
  """
  @spec list_users() :: [User.t()]
  def list_users do
    Repo.all(User)
  end
end
