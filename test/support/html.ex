defmodule Support.HTML do
  @moduledoc """
  Test support functions for working with HTML.
  """

  alias Phoenix.HTML

  def has_selector?(html, selector) do
    Floki.find(html, selector) != []
  end

  @doc """
  Renders a `Phoenix.HTML.safe` object to string.
  """
  def render(safe) do
    HTML.safe_to_string(safe)
  end
end
