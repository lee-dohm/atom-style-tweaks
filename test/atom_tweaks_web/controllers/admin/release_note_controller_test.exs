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

  describe "edit when not logged in" do
    setup [:insert_release_note]

    test "returns unauthorized", context do
      assert_raise NotLoggedInError, fn ->
        request_admin_release_note_edit(context)
      end
    end
  end

  describe "edit when logged in as a normal user" do
    setup [:insert_user, :log_in, :insert_release_note]

    test "returns forbidden", context do
      assert_raise ForbiddenUserError, fn ->
        request_admin_release_note_edit(context)
      end
    end
  end

  describe "edit when logged in as a site admin" do
    setup [:insert_site_admin, :log_in, :insert_release_note, :request_admin_release_note_edit]

    test "displays the title edit box", context do
      edit =
        context.conn
        |> html_response(:ok)
        |> find("#note_title")

      assert attribute(edit, "placeholder") == ["Title"]
      assert attribute(edit, "value") == [context.note.title]
    end

    test "displays the detail url edit box", context do
      edit =
        context.conn
        |> html_response(:ok)
        |> find("#note_detail_url")

      assert attribute(edit, "placeholder") == [
               "https://github.com/lee-dohm/atom-style-tweaks/pull/1234"
             ]

      assert attribute(edit, "value") == [context.note.detail_url]
    end

    test "displays the description text area", context do
      text_area =
        context.conn
        |> html_response(:ok)
        |> find("#note_description")

      assert attribute(text_area, "placeholder") == ["Release notes"]
      assert String.trim(text(text_area)) == md(context.note.description)
    end

    test "displays the submit button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("button[type=\"submit\"].btn.btn-primary")

      assert text(button) == "Update release note"
    end

    test "displays the cancel button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find(".btn.btn-danger")

      assert text(button) =~ "Cancel"
    end
  end

  describe "new when not logged in" do
    test "returns unauthorized", context do
      assert_raise NotLoggedInError, fn ->
        request_admin_release_note_new(context)
      end
    end
  end

  describe "new when logged in as a normal user" do
    setup [:insert_user, :log_in]

    test "returns forbidden", context do
      assert_raise ForbiddenUserError, fn ->
        request_admin_release_note_new(context)
      end
    end
  end

  describe "new when logged in as a site admin" do
    setup [:insert_site_admin, :log_in, :request_admin_release_note_new]

    test "displays the title edit box", context do
      edit =
        context.conn
        |> html_response(:ok)
        |> find("#note_title")

      assert attribute(edit, "placeholder") == ["Title"]
    end

    test "displays the detail url edit box", context do
      edit =
        context.conn
        |> html_response(:ok)
        |> find("#note_detail_url")

      assert attribute(edit, "placeholder") == [
               "https://github.com/lee-dohm/atom-style-tweaks/pull/1234"
             ]
    end

    test "displays the description text area", context do
      text_area =
        context.conn
        |> html_response(:ok)
        |> find("#note_description")

      assert attribute(text_area, "placeholder") == ["Release notes"]
    end

    test "displays the submit button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("button[type=\"submit\"].btn.btn-primary")

      assert text(button) == "Save new release note"
    end
  end
end
