defmodule AtomTweaks.Accounts do
  @moduledoc """
  Context for handling accounts and their operations.
  """
  import Ecto.Query, warn: false

  alias Ecto.Changeset

  alias AtomTweaks.Accounts.Token
  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Repo
  alias AtomTweaks.Tweaks.Star
  alias AtomTweaks.Tweaks.Tweak

  @doc """
  Creates an `Ecto.Changeset` for tracking user changes.
  """
  @spec change_user(User.t()) :: Changeset.t()
  def change_user(user = %User{}) do
    User.changeset(user, %{})
  end

  @doc """
  Counts the number of stars belonging to `user`.
  """
  @spec count_stars(User.t()) :: non_neg_integer
  def count_stars(user = %User{}) do
    Repo.one(from(s in Star, where: s.user_id == ^user.id, select: count(s.user_id)))
  end

  @doc """
  Counts the number of tweaks belonging to `user`.
  """
  @spec count_tweaks(User.t()) :: non_neg_integer
  def count_tweaks(user = %User{}) do
    Repo.one(from(t in Tweak, where: t.created_by == ^user.id, select: count(t.created_by)))
  end

  def change_token(token = %Token{}) do
    Token.changeset(token, %{})
  end

  @doc """
  Creates a token for a user.
  """
  @spec create_token(Map.t()) :: {:ok, Token.t()} | {:error, Changeset.t()}
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes the given `token`.
  """
  @spec delete_token(Token.t()) :: {:ok, Token.t()} | {:error, Changeset.t()}
  def delete_token(token = %Token{}) do
    token
    |> change_token()
    |> Repo.delete()
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
  Lists all tweaks starred by `user`.
  """
  @spec list_stars(User.t()) :: [Tweak.t()] | no_return
  def list_stars(user = %User{}) do
    user
    |> Repo.preload(stars: [:user])
    |> Map.fetch!(:stars)
  end

  @doc """
  Lists all users in the database.
  """
  @spec list_users() :: [User.t()]
  def list_users do
    Repo.all(User)
  end

  @doc """
  Stars `tweak` for `user`.
  """
  @spec star_tweak(User.t(), Tweak.t()) :: {:ok, Star.t()} | {:error, Changeset.t()}
  def star_tweak(user = %User{}, tweak = %Tweak{}) do
    %Star{}
    |> Star.changeset(%{user_id: user.id, tweak_id: tweak.id})
    |> Repo.insert()
  end

  @doc """
  Unstars `tweak` for `user`.
  """
  @spec unstar_tweak(User.t(), Tweak.t()) :: {:ok, Star.t()} | {:error, Changeset.t()}
  def unstar_tweak(user = %User{}, tweak = %Tweak{}) do
    star = Repo.get_by!(Star, user_id: user.id, tweak_id: tweak.id)

    Repo.delete(star)
  end
end
