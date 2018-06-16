defmodule AtomTweaksWeb.PrimerHelpersTest do
  use ExUnit.Case

  import AtomTweaksWeb.PrimerHelpers
  import Floki, only: [attribute: 2, find: 2, text: 1], warn: false

  def render(safe) do
    Phoenix.HTML.safe_to_string(safe)
  end

  describe "avatar" do
    setup do
      user = %{name: "foo", avatar_url: "https://example.com/image.png"}

      {:ok, user: user}
    end

    test "renders correctly without size option", context do
      image =
        context.user
        |> avatar()
        |> render()

      assert find(image, "img.avatar")
      assert attribute(image, "alt") == [context.user.name]
      assert attribute(image, "src") == [context.user.avatar_url]
    end

    test "renders correctly with size option", context do
      image =
        context.user
        |> avatar(size: 60)
        |> render()

      assert find(image, "img.avatar")
      assert attribute(image, "alt") == [context.user.name]
      assert attribute(image, "width") == ["60"]
      assert attribute(image, "height") == ["60"]
      assert hd(attribute(image, "src")) =~ context.user.avatar_url
    end
  end

  describe "counter" do
    test "renders the element", _context do
      counter = render(counter(11))

      assert find(counter, "span.Counter")
      assert text(counter) == "11"
    end
  end

  describe "link_button" do
    test "renders the element", _context do
      button = render(link_button("foo", to: "/path/to/foo"))

      assert find(button, "a")
      assert attribute(button, "type") == ["button"]
      assert attribute(button, "href") == ["/path/to/foo"]
      assert text(button) == "foo"
    end
  end

  describe "menu" do
    test "renders the element", _context do
      menu = render(menu(do: nil))

      assert find(menu, "nav.menu")
    end
  end

  describe "menu_item" do
    test "renders the element with no options", _context do
      item = render(menu_item("foo", "/path/to/foo"))

      assert find(item, "a.menu-item")
      assert attribute(item, "href") == ["/path/to/foo"]
      assert text(item) == "foo"
    end

    test "renders the element as selected", _context do
      item = render(menu_item("foo", "/path/to/foo", selected: true))

      assert find(item, "a.menu-item.selected")
      assert attribute(item, "href") == ["/path/to/foo"]
      assert text(item) == "foo"
    end

    test "renders the element with an octicon", _context do
      item = render(menu_item("foo", "/path/to/foo", octicon: :beaker))

      assert find(item, "a.menu-item")
      assert attribute(item, "href") == ["/path/to/foo"]
      assert text(item) == "foo"
      assert find(item, "a.menu-item svg")
    end
  end

  describe "underline_nav" do
    test "renders the elements", _context do
      nav = render(underline_nav(do: nil))

      assert find(nav, "nav.UnderlineNav")
      assert find(nav, "nav.UnderlineNav .UnderlineNav-body")
    end
  end

  describe "underline_nav_item" do
    test "renders the element without options", _context do
      item = render(underline_nav_item("foo", "/path/to/foo"))

      assert find(item, "a.UnderlineNav-item")
      assert attribute(item, "href") == ["/path/to/foo"]
      assert text(item) == "foo"
    end

    test "renders the element as selected", _context do
      item = render(underline_nav_item("foo", "/path/to/foo", selected: true))

      assert find(item, "a.UnderlineNav-item.selected")
      assert attribute(item, "href") == []
      assert text(item) == "foo"
    end

    test "renders the item with a counter", _context do
      item = render(underline_nav_item("foo", "/path/to/foo", counter: 5))

      assert find(item, "a.UnderlineNav-item span.Counter")
      assert attribute(item, "href") == ["/path/to/foo"]
      assert text(item) == "foo5"
    end
  end
end
