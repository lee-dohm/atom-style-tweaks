defmodule AtomTweaksWeb.HelperCase do
  @moduledoc """
  This module defines the test case to be used by tests of view helper functions.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      import Floki, only: [attribute: 2, find: 2, text: 1], warn: false

      import Test.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AtomTweaks.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AtomTweaks.Repo, {:shared, self()})
    end
  end
end
