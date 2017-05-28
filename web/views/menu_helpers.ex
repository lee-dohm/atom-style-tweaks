defmodule AtomStyleTweaks.MenuHelpers do
  @moduledoc """
  Functions for more easily building menu items.
  """
  use Phoenix.HTML

  alias AtomStyleTweaks.OcticonHelpers

  def menu_item(id, link, text, octicon, selected) do
    class = if selected, do: "menu-item selected", else: "menu-item"

    content_tag(:a, href: link, id: id, class: class) do
      [
        OcticonHelpers.octicon(octicon, %{"width" => "16"}),
        text
      ]
    end
  end
end
