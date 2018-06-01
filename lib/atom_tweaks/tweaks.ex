defmodule AtomTweaks.Tweaks do
  @moduledoc """
  Context for working with tweaks and their operations.
  """
  import Ecto.Query, warn: false

  alias Ecto.Changeset

  alias AtomTweaks.Repo
  alias AtomTweaks.Tweaks.Tweak

  @doc """
  Creates an `Ecto.Changeset` for tracking tweak changes.
  """
  @spec change_tweak(Tweak.t()) :: Changeset.t()
  def change_tweak(tweak = %Tweak{}) do
    Tweak.changeset(tweak, %{})
  end

  @doc """
  Creates a tweak.
  """
  @spec create_tweak(Map.t()) :: {:ok, Tweak.t()} | {:error, Changeset.t()}
  def create_tweak(attrs \\ %{}) do
    %Tweak{}
    |> Tweak.changeset(attrs)
    |> Repo.insert()
  end

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
