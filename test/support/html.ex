defmodule Support.HTML do
  @moduledoc """
  Test support functions for working with HTML.
  """

  alias AtomTweaks.Markdown
  alias Phoenix.HTML

  def has_selector?(html, selector) do
    Floki.find(html, selector) != []
  end

  @doc """
  Returns the HTML version of the structure.

  Accepts either `Floki.html_tree` or `AtomTweaks.Markdown.t`.
  """
  def html(floki_or_markdown)

  def html(markdown = %Markdown{}), do: Markdown.to_html(markdown)

  def html(floki) when is_tuple(floki) or is_list(floki), do: Floki.raw_html(floki)

  @doc """
  Returns the inner HTML of the structure.
  """
  def inner_html(floki)

  def inner_html({_, _, children}), do: Floki.raw_html(children)

  def inner_html([head | _tail]), do: inner_html(head)

  @doc """
  Returns the Markdown version of the `AtomTweaks.Markdown` structure.
  """
  def md(markdown = %Markdown{}), do: markdown.text

  @doc """
  Renders a `Phoenix.HTML.safe` object to string.
  """
  def render(safe) do
    HTML.safe_to_string(safe)
  end
end
