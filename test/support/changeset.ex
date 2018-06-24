defmodule Support.Changeset do
  @moduledoc """
  Functions for testing `Ecto.Changeset` values.
  """

  alias Ecto.Changeset

  @doc """
  Retrieves the error messages associated with `field` from `changeset`.
  """
  @spec error_messages(Changeset.t(), atom) :: [binary]
  def error_messages(changeset, field) do
    changeset.errors
    |> Keyword.get_values(field)
    |> Enum.map(fn error_info -> elem(error_info, 0) end)
  end

  @doc """
  Determines if the `field` in `changeset` has an error.
  """
  @spec error_on?(Changeset.t(), atom) :: boolean
  def error_on?(changeset, field) do
    Enum.any?(changeset.errors, fn error -> ^field = elem(error, 0) end)
  end
end
