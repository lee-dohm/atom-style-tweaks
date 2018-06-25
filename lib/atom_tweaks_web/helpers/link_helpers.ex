defmodule AtomTweaksWeb.LinkHelpers do
  @moduledoc """
  Functions to assist in rendering links.
  """

  use Phoenix.HTML

  def safe_link(text, options) do
    text
    |> link(options)
    |> safe_to_string()
  end
end
