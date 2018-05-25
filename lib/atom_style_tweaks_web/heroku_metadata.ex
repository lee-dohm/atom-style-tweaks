defmodule AtomStyleTweaksWeb.HerokuMetadata do
  @moduledoc """
  A `Plug` that adds [Heroku metadata](https://devcenter.heroku.com/articles/dyno-metadata) to the
  metadata to be rendered on the page via the `PageMetadata` system.
  """
  alias AtomStyleTweaksWeb.PageMetadata

  def init(options), do: options

  def call(conn, options) do
    PageMetadata.add(conn, get(options))
  end

  def get(params \\ []) do
    names =
      case params do
        [] ->
          environment_variable_names()

        [only: only] ->
          only

        [except: except] ->
          Enum.reject(environment_variable_names(), fn name -> name in except end)
      end

    if on_heroku?() do
      Enum.map(names, fn name ->
        [name: name, content: System.get_env(name)]
      end)
    end
  end

  defp environment_variable_names do
    [
      "HEROKU_APP_ID",
      "HEROKU_APP_NAME",
      "HEROKU_DYNO_ID",
      "HEROKU_RELEASE_CREATED_AT",
      "HEROKU_RELEASE_VERSION",
      "HEROKU_SLUG_COMMIT",
      "HEROKU_SLUG_DESCRIPTION"
    ]
  end

  defp on_heroku? do
    System.get_env("HEROKU_DYNO_ID")
  end
end
