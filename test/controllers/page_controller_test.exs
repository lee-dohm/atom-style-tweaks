defmodule AtomStyleTweaks.PageController.Test do
  use AtomStyleTweaks.ConnCase

  def about_page do
    conn = build_conn()

    get(conn, page_path(conn, :about))
  end

  def home_page do
    conn = build_conn()

    get(conn, page_path(conn, :index))
  end

  def home_page(logged_in_as: user) do
    conn = build_conn()
           |> log_in_as(user)

    get(conn, page_path(conn, :index))
  end

  test "index shows home page link" do
    conn = home_page()

    assert find_single_element(conn, "a.masthead-logo")
           |> has_text("Atom Tweaks")
           |> links_to(page_path(conn, :index))
  end

  test "index does not show 'New tweak' button when not logged in" do
    conn = home_page()

    refute find_all_elements(conn, "a#new-tweak-button")
  end

  test "index shows new tweak button when logged in" do
    conn = home_page(logged_in_as: build(:user))

    assert find_single_element(conn, "a#new-tweak-button")
           |> has_text("New tweak")
  end

  test "index shows a list of tweaks" do
    tweaks = insert_list(3, :tweak)
    conn = home_page()

    elements = find_all_elements(conn, "a.title")

    Enum.each(tweaks, fn(tweak) ->
      assert elements
             |> has_text(tweak.title)
             |> links_to(tweak_path(conn, :show, tweak.user.name, tweak.id))
    end)
  end

  test "index shows tweaks tab" do
    conn = home_page()

    assert html_response(conn, 200) =~ "Styles"
  end

  test "index shows About link" do
    conn = home_page()

    assert find_single_element(conn, "footer a#about-link")
           |> has_text("About")
           |> links_to(page_path(conn, :about))
  end

  test "index shows the GitHub link" do
    conn = home_page()

    assert find_single_element(conn, "footer a#github-link")
           |> links_to("https://github.com/lee-dohm/atom-style-tweaks")
  end

  test "about page shows some about text" do
    conn = about_page()

    assert find_single_element(conn, "main h1")
           |> has_text("About Atom Tweaks")
  end
end
