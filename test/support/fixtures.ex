defmodule Support.Fixture do
  @moduledoc """
  Functions for handling test fixtures.
  """

  @doc """
  Gets the contents of the fixture at the path within the fixture directory.

  If the extension of the file is:

  * `.exs` - It is evaluated as Elixir code and the resulting value is returned
  * Anything else is returned as a string
  """
  def fixture(path) do
    path = fixture_path(path)
    extension = Path.extname(path)

    get_contents_by_extension(path, extension)
  end

  @doc """
  Returns the root absolute path for fixtures.
  """
  def fixture_path do
    Path.expand("fixtures", __DIR__)
  end

  @doc """
  Returns the absolute path for the given fixture path.

  If the file name has no extension, it is assumed to be `.exs`.
  """
  def fixture_path(path) do
    case Path.extname(path) do
      "" -> Path.join(fixture_path(), path <> ".exs")
      _ -> Path.join(fixture_path(), path)
    end
  end

  defp get_contents_by_extension(path, ".exs") do
    {result, _} = Code.eval_file(path)
    result
  end

  defp get_contents_by_extension(path, _) do
    path
    |> File.read!()
    |> String.trim()
  end
end
