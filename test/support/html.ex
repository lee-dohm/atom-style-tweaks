defmodule Support.HTML do
  @moduledoc """
  Test support functions for working with HTML.
  """

  @doc """
  Renders a `Phoenix.HTML.safe` object to string.
  """
  def render(safe) do
    Phoenix.HTML.safe_to_string(safe)
  end
end
