defmodule AtomStyleTweaks.MenuHelpers.Test do
  use ExUnit.Case, async: true

  use Phoenix.HTML

  alias AtomStyleTweaks.MenuHelpers

  import AtomStyleTweaks.HtmlAssertions

  test "menu item is rendered correctly" do
    link = MenuHelpers.menu_item("test", "#", "foo", :beaker, false)
    link = safe_to_string(link)

    assert link
           |> find_single_element("a")
           |> has_attribute(:href, "#")
           |> has_attribute(:id, "test")
           |> has_attribute(:class, "menu-item")
           |> has_text("foo")

    assert link
           |> find_single_element("a svg")
           |> has_attribute(:class, "octicons octicons-beaker")
  end

  test "menu item is marked as selected when true is passed" do
    link = MenuHelpers.menu_item("test", "#", "foo", :beaker, true)
    link = safe_to_string(link)

    assert link
           |> find_single_element("a")
           |> has_attribute(:class, "menu-item selected")
  end
end
