defmodule AtomStyleTweaks.MenuHelpers do
  @moduledoc """
  Functions for more easily building menu items.
  """
  use Phoenix.HTML

  @doc """
  Creates a [Primer-style menu item.](http://primercss.io/nav/#menu)

  ## Arguments

  * `id` - identifier for locating the menu item for testing
  * `link` - to where the menu item links
  * `text` - text to display on the menu item
  * `octicon` - [Octicon](https://octicons.github.com/) to display on the menu item
  * `selected` - `true` if the item is selected; `false` otherwise

  Returns the constructed menu item.
  """
  @spec menu_item(String.t, String.t, String.t, AtomStyleTweaks.octicon_name, boolean) :: Phoenix.HTML.safe
  def menu_item(id, link, text, octicon, selected) do
    class = if selected, do: "menu-item selected", else: "menu-item"

    content_tag(:a, href: link, id: id, class: class) do
      [
        PhoenixOcticons.octicon(octicon, %{"width" => "16"}),
        text
      ]
    end
  end
end
