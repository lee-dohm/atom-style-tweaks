defmodule AtomTweaksWeb.UserControllerTest do
  use AtomTweaksWeb.ConnCase

  describe "show regular user without tweaks when not logged in" do
    setup [:insert_user, :request_show_user]

    test "displays the user's name", context do
      header =
        context.conn
        |> html_response(:ok)
        |> find("#user-info-block h2")

      assert text(header) == context.user.name
    end

    test "displays the user's avatar", context do
      image =
        context.conn
        |> html_response(:ok)
        |> find("img.avatar")

      assert hd(attribute(image, "src")) =~ String.replace(context.user.avatar_url, ~r{\?.*$}, "")
    end

    test "does not display the staff badge", context do
      refute has_selector?(html_response(context.conn, :ok), "#staff-badge")
    end

    test "displays the GitHub link", context do
      link =
        context.conn
        |> html_response(:ok)
        |> find("a#github-link")

      assert hd(attribute(link, "href")) == "https://github.com/#{context.user.name}"
    end

    test "does not show the new tweak button", context do
      refute has_selector?(html_response(context.conn, :ok), "#new-tweak-button")
    end

    test "displays a blankslate element", context do
      assert has_selector?(html_response(context.conn, :ok), ".blankslate")
    end
  end

  describe "show site admin user" do
    setup [:insert_site_admin, :request_show_user]

    test "displays the staff badge", context do
      assert has_selector?(html_response(context.conn, :ok), "#staff-badge")
    end
  end

  describe "show user with tweaks" do
    setup [:insert_user_with_tweaks, :request_show_user]

    test "displays tweaks list", context do
      tweaks =
        context.conn
        |> html_response(:ok)
        |> find("a.title")

      assert Enum.all?(context.tweaks, &(text(tweaks) =~ &1.title))

      assert Enum.all?(context.tweaks, fn tweak ->
               path = Routes.tweak_path(context.conn, :show, tweak)
               Enum.member?(attribute(tweaks, "href"), path)
             end)
    end
  end

  describe "show user when logged in" do
    setup [:insert_user, :log_in, :request_show_user]

    test "displays the new tweak button", context do
      assert has_selector?(html_response(context.conn, :ok), "#new-tweak-button")
    end
  end

  describe "show different user when logged in" do
    setup [:insert_user, :log_in, :request_user, :request_show_user]

    test "does not display the new tweak button", context do
      refute has_selector?(html_response(context.conn, :ok), "#new-tweak-button")
    end
  end
end
