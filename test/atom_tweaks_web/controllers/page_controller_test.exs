defmodule AtomTweaksWeb.PageControllerTest do
  use AtomTweaksWeb.ConnCase

  describe "GET home page" do
    setup(context) do
      conn = get(context.conn, :index, [])

      response = html_response(conn, :ok)

      {:ok, conn: conn, response: response}
    end

    test "renders the index.html template", context do
      assert view_template(context.conn) == "index.html"
    end

    test "assigns no current user", context do
      refute fetch_assign(context.conn, :current_user)
    end

    test "assigns an empty tweaks list", context do
      assert fetch_assign(context.conn, :tweaks) == []
    end

    test "assigns an empty params list", context do
      assert fetch_assign(context.conn, :params) == %{}
    end

    test "shows the home page link", context do
      link = find(context.response, "a.masthead-logo")

      assert text(link) == "Atom Tweaks"
      assert attribute(link, "href") == [page_path(context.conn, :index, [])]
    end

    test "does not show the new tweak button", context do
      refute has_selector?(context.response, "a#new-tweak-button")
    end

    test "shows the about page link", context do
      link = find(context.response, "footer a#about-link")

      assert text(link) == "About"
      assert attribute(link, "href") == [page_path(context.conn, :about)]
    end

    test "shows the GitHub link", context do
      link = find(context.response, "footer a#github-link")

      assert attribute(link, "href") == ["https://github.com/lee-dohm/atom-style-tweaks"]
    end
  end

  describe "GET home page with a logged in user" do
    setup(context) do
      user = build(:user)

      conn =
        context.conn
        |> log_in_as(user)
        |> get(page_path(context.conn, :index, []))

      response = html_response(conn, :ok)

      {:ok, conn: conn, response: response, user: user}
    end

    test "assigns a current user", context do
      assert fetch_assign(context.conn, :current_user) == context.user
    end

    test "shows the new tweak button", context do
      link = find(context.response, "a#new-tweak-button")

      assert text(link) == "New tweak"
    end
  end

  describe "GET home page when tweaks exist in the database" do
    setup(context) do
      tweaks = insert_list(3, :tweak)

      conn = get(context.conn, page_path(context.conn, :index, []))

      response = html_response(conn, :ok)

      {:ok, conn: conn, response: response, tweaks: tweaks}
    end

    test "assigns them to the tweaks list", context do
      assigned_tweaks = fetch_assign(context.conn, :tweaks)

      assert Enum.count(assigned_tweaks) == 3
      assert Enum.all?(context.tweaks, &Enum.member?(assigned_tweaks, &1))
    end

    test "displays the links to each tweak", context do
      links = find(context.response, "a.title")

      assert Enum.all?(context.tweaks, fn tweak -> text(links) =~ tweak.title end)
    end
  end

  describe "GET home page when the styles tab is selected" do
    setup(context) do
      insert(:tweak, title: "Init tweak", type: "init")
      tweak = insert(:tweak, title: "Style tweak", type: "style")

      conn = get(context.conn, page_path(context.conn, :index, type: :style))

      response = html_response(conn, :ok)

      {:ok, conn: conn, response: response, tweak: tweak}
    end

    test "only assigns style tweaks to the list", context do
      assigned_tweaks = fetch_assign(context.conn, :tweaks)

      assert Enum.count(assigned_tweaks) == 1
      assert Enum.member?(assigned_tweaks, context.tweak)
    end

    test "displays only the style tweak link", context do
      links = find(context.response, "a.title")

      assert text(links) =~ "Style tweak"
      refute text(links) =~ "Init tweak"
    end
  end

  describe "GET home page when the init tab is selected" do
    setup(context) do
      tweak = insert(:tweak, title: "Init tweak", type: "init")
      insert(:tweak, title: "Style tweak", type: "style")

      conn = get(context.conn, page_path(context.conn, :index, type: :init))

      response = html_response(conn, :ok)

      {:ok, conn: conn, response: response, tweak: tweak}
    end

    test "only assigns init tweaks to the list", context do
      assigned_tweaks = fetch_assign(context.conn, :tweaks)

      assert Enum.count(assigned_tweaks) == 1
      assert Enum.member?(assigned_tweaks, context.tweak)
    end

    test "displays only the init tweak link", context do
      links = find(context.response, "a.title")

      assert text(links) =~ "Init tweak"
      refute text(links) =~ "Style tweak"
    end
  end

  describe "GET about page" do
    setup(context) do
      response =
        context.conn
        |> get(page_path(context.conn, :about))
        |> html_response(:ok)

      {:ok, response: response}
    end

    test "it displays some about text", context do
      header = find(context.response, "main h1")

      assert text(header) == "About Atom Tweaks"
    end
  end
end
