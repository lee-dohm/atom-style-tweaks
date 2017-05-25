defmodule AtomStyleTweaks.PageController.Test do
  use AtomStyleTweaks.ConnCase

  test "index shows home page link" do
    conn = request(:page_path, :index)

    assert html_response(conn, 200) =~ "Atom Tweaks"
    assert html_response(conn, 200) =~ "href=\"#{page_path(conn, :index)}\""
  end

  test "index does not show 'New tweak' button when not logged in" do
    conn = request(:page_path, :index)

    refute html_response(conn, 200) =~ "New tweak"
  end

  test "index shows new tweak button when logged in" do
    conn = request(:page_path, :index, :logged_in)

    assert html_response(conn, 200) =~ "New tweak"
  end

  test "index shows a list of tweaks" do
    styles = insert_list(3, :style)
    conn = request(:page_path, :index)

    Enum.each(styles, fn(style) ->
      assert html_response(conn, 200) =~ style.title
      assert html_response(conn, 200) =~ style.user.name
    end)
  end

  test "index shows styles tab" do
    conn = request(:page_path, :index)

    assert html_response(conn, 200) =~ "Styles"
  end

  test "index shows About link" do
    conn = request(:page_path, :index)

    assert html_response(conn, 200) =~ "About"
    assert html_response(conn, 200) =~ page_path(conn, :about)
  end

  test "index shows the GitHub link" do
    conn = request(:page_path, :index)

    assert html_response(conn, 200) =~ "https://github.com/lee-dohm/atom-style-tweaks"
  end

  test "about page shows some about text" do
    conn = request(:page_path, :about)

    assert html_response(conn, 200) =~ "About Atom Tweaks"
  end
end
