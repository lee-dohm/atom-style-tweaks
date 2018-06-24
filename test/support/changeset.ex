defmodule Support.Changeset do
  @moduledoc """
  Functions for testing `Ecto.Changeset` values.
  """

  alias Ecto.Changeset

  @doc """
  Retrieves the error messages associated with `field` from `changeset`.

  Use `error_on?/2` first to determine there are errors on the expected field.
  """
  @spec error_messages(Changeset.t(), atom) :: [binary]
  def error_messages(changeset, field) do
    changeset.errors
    |> Keyword.get_values(field)
    |> Enum.map(fn {message, _} -> message end)
  end

  @doc """
  Determines if the `field` in `changeset` has an error.
  """
  @spec error_on?(Changeset.t(), atom) :: boolean
  def error_on?(changeset, field) do
    Enum.any?(changeset.errors, fn
      {^field, _} -> true
      _ -> false
    end)
  end
end
