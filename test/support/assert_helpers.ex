defmodule Support.AssertHelpers do
  @moduledoc """
  Customized assertions for tests.
  """

  @doc """
  Retrieves the error messages associated with `field` from `changeset`.
  """
  def error_messages(changeset, field) do
    changeset.errors
    |> Keyword.get_values(field)
    |> Enum.map(fn tuple -> elem(tuple, 0) end)
  end

  @doc """
  Determines if the `field` in `changeset` has an error.
  """
  @spec error_on?(Ecto.Changeset.t(), atom) :: boolean
  def error_on?(changeset, field) do
    Enum.any?(changeset.errors, fn error -> ^field = elem(error, 0) end)
  end
end
