defmodule AtomStyleTweaksWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      import Phoenix.Controller

      import AtomStyleTweaks.Factory
      import AtomStyleTweaksWeb.Router.Helpers

      import Floki, only: [attribute: 2, find: 2, text: 1]

      import Support.SetupHelpers

      import Test.Helpers

      # The default endpoint for testing
      @endpoint AtomStyleTweaksWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AtomStyleTweaks.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AtomStyleTweaks.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end