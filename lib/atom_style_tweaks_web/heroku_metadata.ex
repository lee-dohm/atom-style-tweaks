defmodule AtomStyleTweaksWeb.HerokuMetadata do
  @moduledoc """
  Makes [Heroku metadata](https://devcenter.heroku.com/articles/dyno-metadata) available to the
  application.
  """

  @doc """
  Determines whether the application is running on Heroku.
  """
  @spec on_heroku? :: boolean
  def on_heroku?, do: !is_nil(dyno_id())

  @doc """
  Returns the UUID for the running Heroku application.
  """
  @spec app_id :: String.t
  def app_id, do: get_env(:app_id)

  @doc """
  Returns the Heroku application name.
  """
  @spec app_name :: String.t
  def app_name, do: get_env(:app_name)

  @doc """
  Returns the Heroku dyno UUID.
  """
  @spec dyno_id :: String.t
  def dyno_id, do: get_env(:dyno_id)

  @doc """
  Returns the timestamp of when the current release was created.
  """
  @spec release_created_at :: String.t
  def release_created_at, do: get_env(:release_created_at)

  @doc """
  Returns the version string of the current release.
  """
  @spec release_version :: String.t
  def release_version, do: get_env(:release_version)

  @doc """
  Returns the Git SHA of the latest commit contained in the Heroku release slug.
  """
  @spec slug_commit :: String.t
  def slug_commit, do: get_env(:slug_commit)

  @doc """
  Returns the summary of the latest commit contained in the Heroku release slug.
  """
  @spec slug_description :: String.t
  def slug_description, do: get_env(:slug_description)

  defp get_env(key), do: Application.get_env(:atom_style_tweaks, __MODULE__)[key]
end
