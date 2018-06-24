defmodule AtomTweaksWeb.HerokuMetadata do
  @moduledoc """
  A `Plug` that adds [Heroku metadata](https://devcenter.heroku.com/articles/dyno-metadata) to the
  metadata to be rendered on the page via the `PageMetadata` system.
  """
  alias AtomTweaksWeb.PageMetadata

  @environment_variable_names [
    "HEROKU_APP_ID",
    "HEROKU_APP_NAME",
    "HEROKU_DYNO_ID",
    "HEROKU_RELEASE_CREATED_AT",
    "HEROKU_RELEASE_VERSION",
    "HEROKU_SLUG_COMMIT",
    "HEROKU_SLUG_DESCRIPTION"
  ]

  @doc """
  Initialize the plug.

  When given no options, the full set of Heroku environment variables are applied as metadata:

  * `HEROKU_APP_ID`
  * `HEROKU_APP_NAME`
  * `HEROKU_DYNO_ID`
  * `HEROKU_RELEASE_CREATED_AT`
  * `HEROKU_RELEASE_VERSION`
  * `HEROKU_SLUG_COMMIT`
  * `HEROKU_SLUG_DESCRIPTION`

  See [the Heroku documentation](https://devcenter.heroku.com/articles/dyno-metadata) for what each
  one means.

  ## Options

  The options are mutually exclusive:

  * `:except` - Will include all environment variables except those listed
  * `:only` - Will only include the listed environment variables
  """
  def init(options), do: options

  @doc """
  Adds the configured Heroku metadata to the page.
  """
  def call(conn, options) do
    PageMetadata.add(conn, get(options))
  end

  def get(params \\ []) do
    names = get_names(params)

    if on_heroku?() do
      Enum.map(names, fn name ->
        [name: name, content: System.get_env(name)]
      end)
    end
  end

  defp get_names([]), do: @environment_variable_names
  defp get_names(only: only), do: only

  defp get_names(except: except) do
    Enum.reject(@environment_variable_names, fn name -> name in except end)
  end

  defp on_heroku? do
    System.get_env("HEROKU_DYNO_ID")
  end
end
