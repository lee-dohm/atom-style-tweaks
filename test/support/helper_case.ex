defmodule AtomTweaksWeb.HelperCase do
  @moduledoc """
  This module defines the test case to be used by tests of view helper functions.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  alias AtomTweaks.Repo

  using do
    quote do
      import Floki, only: [attribute: 2, find: 2, text: 1], warn: false

      import Support.HTML
      import Test.Helpers
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end
  end
end
