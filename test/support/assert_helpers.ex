defmodule Support.AssertHelpers do
  @moduledoc """
  Customized assertions for tests.
  """

  @doc """
  Determines if the `field` in `changeset` has an error.
  """
  @spec has_error_on?(Ecto.Changeset.t(), atom) :: boolean
  def has_error_on?(changeset, field) do
    Enum.any?(changeset.errors, fn error -> ^field = elem(error, 0) end)
  end
end
