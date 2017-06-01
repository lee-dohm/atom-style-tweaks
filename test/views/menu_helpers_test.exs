defmodule AtomStyleTweaks.MenuHelpers.Test do
  use ExUnit.Case, async: true

  use Phoenix.HTML

  alias AtomStyleTweaks.MenuHelpers

  import AtomStyleTweaks.HtmlAssertions

  test "menu item is rendered correctly" do
    link = MenuHelpers.menu_item("test", "#", "foo", :beaker, false)
           |> safe_to_string

    assert find_single_element(link, "a")
           |> has_attribute(:href, "#")
           |> has_attribute(:id, "test")
           |> has_attribute(:class, "menu-item")
           |> has_text("foo")

    assert find_single_element(link, "a svg")
           |> has_attribute(:class, "octicons octicons-beaker")
  end

  test "menu item is marked as selected when true is passed" do
    link = MenuHelpers.menu_item("test", "#", "foo", :beaker, true)
           |> safe_to_string

    assert find_single_element(link, "a")
           |> has_attribute(:class, "menu-item selected")
  end
end
