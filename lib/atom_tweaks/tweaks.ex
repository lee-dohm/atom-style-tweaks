defmodule AtomTweaks.Tweaks do
  @moduledoc """
  Context for working with tweaks and their operations.
  """
  import Ecto.Query, warn: false

  alias Ecto.Changeset

  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Repo
  alias AtomTweaks.Tweaks.Star
  alias AtomTweaks.Tweaks.Tweak

  @doc """
  Creates an `Ecto.Changeset` for tracking tweak changes.
  """
  @spec change_tweak(Tweak.t()) :: Changeset.t()
  def change_tweak(tweak = %Tweak{}) do
    Tweak.changeset(tweak, %{})
  end

  @doc """
  Counts the number of forks of the given `tweak`.
  """
  @spec count_forks(Tweak.t()) :: non_neg_integer
  def count_forks(tweak = %Tweak{}) do
    Repo.one(from(t in Tweak, where: t.parent == ^tweak.id, select: count(t.parent)))
  end

  @doc """
  Creates a new tweak.
  """
  @spec create_tweak(Map.t()) :: {:ok, Tweak.t()} | {:error, Changeset.t()}
  def create_tweak(attrs \\ %{}) do
    %Tweak{}
    |> Tweak.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Forks the `tweak` by the `user`.

  Returns the newly created tweak or an error changeset.
  """
  @spec fork_tweak(Tweak.t(), User.t()) :: {:ok, Tweak.t()} | {:error, Changeset.t()}
  def fork_tweak(original_tweak = %Tweak{}, user = %User{}) do
    params = Tweak.fork_params(original_tweak, user)

    %Tweak{}
    |> Tweak.changeset(params)
    |> Tweak.validate_fork_by_different_user(original_tweak)
    |> Repo.insert()
  end

  @doc """
  Gets a tweak by ID.
  """
  def get_tweak!(id) do
    Tweak
    |> Repo.get!(id)
    |> Repo.preload([:user, :stargazers])
  end

  @doc """
  Checks to see if the given `tweak` is starred by `user`.
  """
  @spec is_starred?(Tweak.t(), User.t() | nil | atom) :: boolean
  def is_starred?(tweak, user)

  def is_starred?(%Tweak{id: tweak_id}, %User{id: user_id}) do
    Repo.one(from(s in Star, where: s.tweak_id == ^tweak_id, where: s.user_id == ^user_id)) != nil
  end

  def is_starred?(%Tweak{}, _), do: false

  @doc """
  Lists the users that have starred the `tweak`.
  """
  @spec list_stargazers(Tweak.t()) :: [User.t()]
  def list_stargazers(tweak = %Tweak{}) do
    tweak
    |> Repo.preload(:stargazers)
    |> Map.fetch!(:stargazers)
  end
end
