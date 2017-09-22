defmodule AtomStyleTweaksWeb.PageController.Test do
  use AtomStyleTweaksWeb.ConnCase

  def about_page do
    conn = build_conn()

    get(conn, page_path(conn, :about))
  end

  def home_page do
    conn = build_conn()

    get(conn, page_path(conn, :index))
  end

  def home_page(options) do
    user = Keyword.get(options, :logged_in_as)
    params = Keyword.delete(options, :logged_in_as)

    conn = build_conn()
    conn = if user, do: log_in_as(conn, user), else: conn

    get(conn, page_path(conn, :index, params))
  end

  test "index shows home page link" do
    conn = home_page()

    assert conn
           |> find_single_element("a.masthead-logo")
           |> has_text("Atom Tweaks")
           |> links_to(page_path(conn, :index))
  end

  test "index shows All tab and it is selected by default" do
    conn = home_page()

    assert conn
           |> find_single_element("a#all-menu-item.selected")
           |> has_text("All")
           |> links_to(page_path(conn, :index))

    assert find_single_element(conn, "a#all-menu-item > .octicons.octicons-beaker")
  end

  test "index shows Styles tab" do
    conn = home_page()

    assert conn
           |> find_single_element("a#styles-menu-item")
           |> has_text("Styles")
           |> links_to(page_path(conn, :index, type: :style))

    assert find_single_element(conn, "a#styles-menu-item > .octicons.octicons-paintcan")
  end

  test "index shows Init tab" do
    conn = home_page()

    assert conn
           |> find_single_element("a#init-menu-item")
           |> has_text("Init")
           |> links_to(page_path(conn, :index, type: :init))

    assert find_single_element(conn, "a#init-menu-item > .octicons.octicons-code")
  end

  test "index shows init tab as selected when type is set to init" do
    conn = home_page(type: :init)

    refute find_single_element(conn, "a#all-menu-item.selected")
    assert find_single_element(conn, "a#init-menu-item.selected")
  end

  test "index shows styles tab as selected when type is set to style" do
    conn = home_page(type: :style)

    refute find_single_element(conn, "a#all-menu-item.selected")
    assert find_single_element(conn, "a#styles-menu-item.selected")
  end

  test "index shows only init tweaks when type is set to init" do
    insert(:tweak, title: "Init tweak", type: "init")
    insert(:tweak, title: "Style tweak", type: "style")

    conn = home_page(type: :init)

    elements = find_all_elements(conn, "a.title")

    assert elements
           |> has_text("Init tweak")

    Enum.each(elements, fn(element) ->
      refute element
             |> get_text == "Style tweak"
    end)
  end

  test "index shows only style tweaks when type is set to style" do
    insert(:tweak, title: "Init tweak", type: "init")
    insert(:tweak, title: "Style tweak", type: "style")

    conn = home_page(type: :style)

    elements = find_all_elements(conn, "a.title")

    assert elements
           |> has_text("Style tweak")

    Enum.each(elements, fn(element) ->
      refute element
             |> get_text == "Init tweak"
    end)
  end

  test "index does not show 'New tweak' button when not logged in" do
    conn = home_page()

    refute find_all_elements(conn, "a#new-tweak-button")
  end

  test "index shows new tweak button when logged in" do
    conn = home_page(logged_in_as: build(:user))

    assert conn
           |> find_single_element("a#new-tweak-button")
           |> has_text("New tweak")
  end

  test "index shows a list of tweaks" do
    tweaks = insert_list(3, :tweak)
    conn = home_page()

    elements = find_all_elements(conn, "a.title")

    Enum.each(tweaks, fn(tweak) ->
      assert elements
             |> has_text(tweak.title)
             |> links_to(user_tweak_path(conn, :show, tweak.user.name, tweak.id))
    end)
  end

  test "index shows tweaks tab" do
    conn = home_page()

    assert html_response(conn, 200) =~ "Styles"
  end

  test "index shows About link" do
    conn = home_page()

    assert conn
           |> find_single_element("footer a#about-link")
           |> has_text("About")
           |> links_to(page_path(conn, :about))
  end

  test "index shows the GitHub link" do
    conn = home_page()

    assert conn
           |> find_single_element("footer a#github-link")
           |> links_to("https://github.com/lee-dohm/atom-style-tweaks")
  end

  test "about page shows some about text" do
    conn = about_page()

    assert conn
           |> find_single_element("main h1")
           |> has_text("About Atom Tweaks")
  end
end
