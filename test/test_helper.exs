defmodule Test.Helpers do
  @moduledoc """
  Helper functions for tests.
  """

  @doc """
  Fetches the value for `key` from the `t:Plug.Conn/0` assigns.
  """
  def fetch_assign(conn, key) do
    {:ok, value} = Map.fetch(conn.assigns, key)

    value
  end

  def has_selector?(html, selector) do
    Floki.find(html, selector) != []
  end
end

{:ok, _} = Application.ensure_all_started(:faker_elixir_octopus)
{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(AtomTweaks.Repo, :manual)
