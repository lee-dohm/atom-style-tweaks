defmodule AtomTweaksWeb.Admin.ReleaseNoteControllerTest do
  use AtomTweaksWeb.ConnCase

  alias AtomTweaksWeb.ForbiddenUserError
  alias AtomTweaksWeb.NotLoggedInError

  describe "index when not logged in" do
    test "returns unauthorized", context do
      assert_raise NotLoggedInError, fn ->
        request_admin_release_note_index(context)
      end
    end
  end

  describe "index when logged in as non-admin user" do
    setup [:insert_user, :log_in]

    test "returns forbidden", context do
      assert_raise ForbiddenUserError, fn ->
        request_admin_release_note_index(context)
      end
    end
  end

  describe "index when logged in as an admin with no notes" do
    setup [:insert_site_admin, :log_in, :request_admin_release_note_index]

    test "displays a blankslate element", context do
      blankslate =
        context.conn
        |> html_response(:ok)
        |> find(".blankslate")

      assert text(blankslate) == "No release notes for you to see here"
    end
  end

  describe "index when logged in as an admin and there are notes" do
    setup [:insert_site_admin, :log_in, :insert_release_note, :request_admin_release_note_index]

    test "displays the release notes list", context do
      link =
        context.conn
        |> html_response(:ok)
        |> find("a.title")

      assert text(link) == context.note.title

      assert Routes.admin_release_note_path(context.conn, :show, context.note) in attribute(
               link,
               "href"
             )
    end
  end
end
