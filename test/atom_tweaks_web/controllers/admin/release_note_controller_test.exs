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

    test "displays the link to the release note record", context do
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

    test "displays when the release note was created", context do
      created =
        context.conn
        |> html_response(:ok)
        |> find(".release-info")

      assert text(created) == "Released about now"
    end
  end

  describe "show when not logged in" do
    setup [:insert_release_note]

    test "returns unauthorized", context do
      assert_raise NotLoggedInError, fn ->
        request_admin_release_note_show(context)
      end
    end
  end

  describe "show when logged in as a normal user" do
    setup [:insert_user, :log_in, :insert_release_note]

    test "returns forbidden", context do
      assert_raise ForbiddenUserError, fn ->
        request_admin_release_note_show(context)
      end
    end
  end

  describe "show when logged in as an admin user" do
    setup [:insert_site_admin, :log_in, :insert_release_note, :request_admin_release_note_show]

    test "displays the note's title", context do
      title =
        context.conn
        |> html_response(:ok)
        |> find(".release-note-title")

      assert text(title) == context.note.title
    end

    test "displays an edit button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("a#edit-button")

      path = Routes.admin_release_note_path(context.conn, :edit, context.note)

      assert path in attribute(button, "href")
    end

    test "displays the note's description", context do
      description =
        context.conn
        |> html_response(:ok)
        |> find(".markdown-body")

      assert inner_html(description) == String.trim(html(context.note.description))
    end
  end
end
