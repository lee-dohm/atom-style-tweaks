defmodule AtomTweaks.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox
  alias Ecto.Changeset

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import AtomTweaks.DataCase
      import AtomTweaks.Factory

      import Support.Changeset
      import Support.Setup

      alias AtomTweaks.Repo
    end
  end

  setup tags do
    :ok = Sandbox.checkout(AtomTweaks.Repo)

    unless tags[:async] do
      Sandbox.mode(AtomTweaks.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  Transforms changeset errors into a map of messages.

  ## Examples

  ```
  assert {:error, changeset} = Accounts.create_user(%{password: "short"})
  assert "password is too short" in errors_on(changeset).password
  assert %{password: ["password is too short"]} = errors_on(changeset)
  ```
  """
  def errors_on(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  @doc """
  Returns the list of errors on `field` in the `changeset`.

  ## Examples

  ```
  assert "password is too short" in errors_on(changeset, :password)
  ```
  """
  def errors_on(changeset, field), do: Map.get(errors_on(changeset), field)
end
