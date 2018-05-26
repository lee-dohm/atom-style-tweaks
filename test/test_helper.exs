defmodule Test.Helpers do
  @moduledoc """
  Helper functions for tests.
  """

  alias Plug.Test, as: PlugTest

  def attribute_in(html, selector, attribute) do
    html
    |> Floki.find(selector)
    |> Floki.attribute(attribute)
    |> strip_list_when_single()
  end

  @doc """
  Fetches the value for `key` from the `t:Plug.Conn/0` assigns.
  """
  def fetch_assign(conn, key) do
    {:ok, value} = Map.fetch(conn.assigns, key)

    value
  end

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

  def has_selector?(html, selector) do
    Floki.find(html, selector) != []
  end

  @doc """
  Simulates being logged in as the supplied `user`.
  """
  def log_in_as(conn, user) do
    PlugTest.init_test_session(conn, %{current_user: user})
  end

  def text_in(html, selector) do
    html
    |> Floki.find(selector)
    |> Floki.text()
  end

  defp strip_list_when_single([head | []]), do: head
  defp strip_list_when_single(list), do: list
end

{:ok, _} = Application.ensure_all_started(:faker_elixir_octopus)
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(AtomTweaks.Repo, :manual)
