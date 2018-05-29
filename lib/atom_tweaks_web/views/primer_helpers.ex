defmodule AtomTweaksWeb.PrimerHelpers do
  @moduledoc """
  Helper functions for generating elements that work with [Primer](https://primer.github.io/).
  """
  use Phoenix.HTML

  @doc """
  Generates a link button with the given text and options.

  ## Options

  * **required** `:to` -- the URL to link to
  """
  def link_button(text, options \\ []) do
    options = Keyword.merge(options, type: "button")

    link(text, options)
  end
end
