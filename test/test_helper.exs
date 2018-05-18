defmodule Test.Helpers do
  def fixture_path do
    Path.expand("fixtures", __DIR__)
  end

  def fixture_path(filename) do
    case Path.extname(filename) do
      "" -> Path.join(fixture_path(), filename <> ".exs")
      _ -> Path.join(fixture_path(), filename)
    end
  end

  def fixture(filename) do
    path = fixture_path(filename)

    case Path.extname(path) do
      ".exs" ->
        {result, _} = Code.eval_file(path)
        result

      _ ->
        path
        |> File.read!()
        |> String.trim()
    end
  end
end

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(AtomStyleTweaks.Repo, :manual)
