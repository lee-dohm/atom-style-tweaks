defmodule AtomStyleTweaks.PageController.Test do
  use AtomStyleTweaks.ConnCase

  test "index shows home page link" do
    conn = request(:page_path, :index)

    assert find_element(conn, "a.masthead-logo")
           |> has_text("Atom Tweaks")
           |> links_to(page_path(conn, :index))
  end

  test "index does not show 'New tweak' button when not logged in" do
    conn = request(:page_path, :index)

    refute find_element(conn, "a#new-tweak-button")
  end

  test "index shows new tweak button when logged in" do
    conn = request(:page_path, :index, logged_in: true)

    assert find_element(conn, "a#new-tweak-button")
           |> has_text("New tweak")
  end

  test "index shows a list of tweaks" do
    tweaks = insert_list(3, :tweak)
    conn = request(:page_path, :index)

    Enum.each(tweaks, fn(tweak) ->
      assert html_response(conn, 200) =~ tweak.title
      assert html_response(conn, 200) =~ tweak.user.name
    end)
  end

  test "index shows tweaks tab" do
    conn = request(:page_path, :index)

    assert html_response(conn, 200) =~ "Styles"
  end

  test "index shows About link" do
    conn = request(:page_path, :index)

    assert find_element(conn, "footer a#about-link")
           |> has_text("About")
           |> links_to(page_path(conn, :about))
  end

  test "index shows the GitHub link" do
    conn = request(:page_path, :index)

    assert find_element(conn, "footer a#github-link")
           |> links_to("https://github.com/lee-dohm/atom-style-tweaks")
  end

  test "about page shows some about text" do
    conn = request(:page_path, :about)

    assert find_element(conn, "main h1")
           |> has_text("About Atom Tweaks")
  end
end
