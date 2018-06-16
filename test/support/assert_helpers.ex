defmodule Support.AssertHelpers do
  @moduledoc """
  Customized assertions for tests.
  """

  def has_error_on?(changeset, field) do
    Enum.any?(changeset.errors, fn error -> ^field = elem(error, 0) end)
  end
end
