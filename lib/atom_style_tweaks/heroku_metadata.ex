defmodule AtomStyleTweaks.HerokuMetadata do
  @moduledoc """
  Makes Heroku metadata available to the application.

  See: https://devcenter.heroku.com/articles/dyno-metadata
  """

  def on_heroku?, do: !is_nil(dyno_id())

  def app_id, do: get_env(:app_id)
  def app_name, do: get_env(:app_name)
  def dyno_id, do: get_env(:dyno_id)
  def release_created_at, do: get_env(:release_created_at)
  def release_version, do: get_env(:release_version)
  def slug_commit, do: get_env(:slug_commit)
  def slug_description, do: get_env(:slug_description)

  defp get_env(key), do: Application.get_env(:atom_style_tweaks, __MODULE__)[key]
end
