defmodule AtomTweaksWeb.PageControllerTest do
  use AtomTweaksWeb.ConnCase

  describe "home page when not logged in" do
    setup [:request_page_index]

    use AtomTweaksWeb.Shared.HeaderTests, logged_in: false
    use AtomTweaksWeb.Shared.FooterTests

    test "does not show the new tweak button", context do
      response = html_response(context.conn, :ok)

      refute has_selector?(response, "a#new-tweak-button")
    end

    test "shows the all tweaks menu item", context do
      item =
        context.conn
        |> html_response(:ok)
        |> find("a#all-menu-item")

      assert text(item) == "All"
      assert attribute(item, "href") == [Routes.page_path(context.conn, :index)]
      assert selected?(item)
    end

    test "shows the init tweaks menu item", context do
      item =
        context.conn
        |> html_response(:ok)
        |> find("a#init-menu-item")

      assert text(item) == "Init"
      assert attribute(item, "href") == [Routes.page_path(context.conn, :index, type: "init")]
      refute selected?(item)
    end

    test "shows the style tweaks menu item", context do
      item =
        context.conn
        |> html_response(:ok)
        |> find("a#styles-menu-item")

      assert text(item) == "Styles"
      assert attribute(item, "href") == [Routes.page_path(context.conn, :index, type: "style")]
      refute selected?(item)
    end
  end

  describe "home page when logged in as a normal user" do
    setup [:insert_user, :log_in, :request_page_index]

    use AtomTweaksWeb.Shared.HeaderTests, logged_in: true
    use AtomTweaksWeb.Shared.FooterTests

    test "shows the new tweak button", context do
      link =
        context.conn
        |> html_response(:ok)
        |> find("a#new-tweak-button")

      assert text(link) == "New tweak"
      assert attribute(link, "href") == [Routes.tweak_path(context.conn, :new)]
    end
  end

  describe "GET home page when tweaks exist in the database" do
    setup(context) do
      tweaks = insert_list(3, :tweak)

      conn = get(context.conn, Routes.page_path(context.conn, :index, []))

      response = html_response(conn, :ok)

      {:ok, conn: conn, response: response, tweaks: tweaks}
    end

    test "assigns them to the tweaks list", context do
      assigned_tweaks = fetch_assign(context.conn, :tweaks)

      assert Enum.count(assigned_tweaks) == 3

      assert Enum.all?(
               context.tweaks,
               &Enum.find(assigned_tweaks, fn item -> item.id == &1.id end)
             )
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

      conn = get(context.conn, Routes.page_path(context.conn, :index, type: :style))

      response = html_response(conn, :ok)

      {:ok, conn: conn, response: response, tweak: tweak}
    end

    test "only assigns style tweaks to the list", context do
      assigned_tweaks = fetch_assign(context.conn, :tweaks)

      assert Enum.count(assigned_tweaks) == 1
      assert hd(assigned_tweaks).id == context.tweak.id
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

      conn = get(context.conn, Routes.page_path(context.conn, :index, type: :init))

      response = html_response(conn, :ok)

      {:ok, conn: conn, response: response, tweak: tweak}
    end

    test "only assigns init tweaks to the list", context do
      assigned_tweaks = fetch_assign(context.conn, :tweaks)

      assert Enum.count(assigned_tweaks) == 1
      assert hd(assigned_tweaks).id == context.tweak.id
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
        |> get(Routes.page_path(context.conn, :about))
        |> html_response(:ok)

      {:ok, response: response}
    end

    test "it displays some about text", context do
      header = find(context.response, "main h1")

      assert text(header) == "About Atom Tweaks"
    end
  end
end
