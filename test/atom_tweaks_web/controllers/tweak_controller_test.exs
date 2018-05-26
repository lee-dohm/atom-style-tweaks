defmodule AtomTweaksWeb.TweakControllerTest do
  use AtomTweaksWeb.ConnCase

  describe "create tweak when not logged in" do
    setup [:insert_user, :valid_tweak_params, :request_create_tweak]

    test "returns status unauthorized", context do
      assert response(context.conn, :unauthorized)
    end
  end

  describe "create valid tweak when logged in" do
    setup [:insert_user, :log_in, :valid_tweak_params, :request_create_tweak]

    test "redirects to user's tweaks list", context do
      path = user_tweak_path(context.conn, :index, context.current_user.name)

      assert redirected_to(context.conn, :found) =~ path
    end
  end

  describe "create invalid tweak when logged in" do
    setup [:insert_user, :log_in, :invalid_tweak_params, :request_create_tweak]

    test "renders the new tweak template", context do
      assert html_response(context.conn, :ok)
      assert view_template(context.conn) == "new.html"
    end
  end

  describe "attempting to create a tweak for a different user" do
    setup [:insert_user, :log_in, :valid_tweak_params, :request_user, :request_create_tweak]

    test "returns status not found", context do
      assert response(context.conn, :not_found)
    end
  end

  describe "attempting to create a tweak for a non-existent user" do
    setup [
      :insert_user,
      :log_in,
      :valid_tweak_params,
      :invalid_request_user,
      :request_create_tweak
    ]

    test "returns status not found", context do
      assert response(context.conn, :not_found)
    end
  end

  describe "new tweak when not logged in" do
    setup [:insert_user, :request_new_tweak]

    test "returns status unauthorized", context do
      assert response(context.conn, :unauthorized)
    end
  end

  describe "new tweak when logged in" do
    setup [:insert_user, :log_in, :request_new_tweak]

    test "has a tweak title input element", context do
      input =
        context.conn
        |> html_response(:ok)
        |> find("input#tweak_title")

      assert attribute(input, "placeholder") == ["Title"]
    end

    test "has a tweak type select element", context do
      assert has_selector?(html_response(context.conn, :ok), "select#tweak_type")
    end

    test "has a tweak code text area element", context do
      text_area =
        context.conn
        |> html_response(:ok)
        |> find("textarea#tweak_code")

      assert attribute(text_area, "placeholder") == ["Enter tweak code"]
    end

    test "has a tweak description text area element", context do
      text_area =
        context.conn
        |> html_response(:ok)
        |> find("textarea#tweak_description")

      assert attribute(text_area, "placeholder") == ["Describe the tweak"]
    end

    test "has a submit button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("button.btn.btn-primary")

      assert text(button) == "Save new tweak"
      assert attribute(button, "type") == ["submit"]
    end
  end

  describe "attempting to request a new tweak for an invalid user" do
    setup [:insert_user, :log_in, :invalid_request_user, :request_new_tweak]

    test "returns status not found", context do
      assert html_response(context.conn, :not_found)
    end
  end

  describe "attempting to request a new tweak for a different user" do
    setup [:insert_user, :log_in, :request_user, :request_new_tweak]

    test "returns status not found", context do
      assert html_response(context.conn, :not_found)
    end
  end

  describe "request edit tweak when not logged in" do
    setup [:insert_tweak, :request_edit_tweak]

    test "returns status unauthorized", context do
      assert html_response(context.conn, :unauthorized)
    end
  end

  describe "edit tweak when logged in" do
    setup [:insert_tweak, :log_in, :request_edit_tweak]

    test "has tweak title input element", context do
      input =
        context.conn
        |> html_response(:ok)
        |> find("input#tweak_title")

      assert attribute(input, "placeholder") == ["Title"]
    end

    test "has tweak type select element", context do
      assert has_selector?(html_response(context.conn, :ok), "select#tweak_type")
    end

    test "has tweak code textarea element", context do
      text_area =
        context.conn
        |> html_response(:ok)
        |> find("textarea#tweak_code")

      assert attribute(text_area, "placeholder") == ["Enter tweak code"]
    end

    test "has tweak description textarea element", context do
      text_area =
        context.conn
        |> html_response(:ok)
        |> find("textarea#tweak_description")

      assert attribute(text_area, "placeholder") == ["Describe the tweak"]
    end

    test "has submit button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("button.btn.btn-primary")

      assert text(button) == "Update tweak"
      assert attribute(button, "type") == ["submit"]
    end

    test "has a cancel button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("a.btn.btn-danger")

      path = user_tweak_path(context.conn, :show, context.current_user, context.tweak)

      assert attribute(button, "href") == [path]
    end
  end

  describe "attempting to request to edit a tweak of an invalid user" do
    setup [:insert_tweak, :log_in, :invalid_request_user, :request_edit_tweak]

    test "returns status not found", context do
      assert response(context.conn, :not_found)
    end
  end

  describe "attempting to request to edit a tweak of a different user" do
    setup [:insert_tweak, :log_in, :request_user, :request_edit_tweak]

    test "returns status not found", context do
      assert response(context.conn, :not_found)
    end
  end

  describe "show tweak when not logged in" do
    setup [:insert_tweak, :request_show_tweak]

    test "displays the tweak's title", context do
      title =
        context.conn
        |> html_response(:ok)
        |> find("main h3")

      assert text(title) == context.tweak.title
    end

    test "displays the tweak's code", context do
      code =
        context.conn
        |> html_response(:ok)
        |> find("code")

      assert text(code) == context.tweak.code
    end

    test "displays the tweak's description", context do
      description =
        context.conn
        |> html_response(:ok)
        |> find(".tweak-description")

      assert text(description) == context.tweak.description
    end

    test "does not show the edit button", context do
      refute has_selector?(html_response(context.conn, :ok), "a#edit-button")
    end
  end

  describe "show tweak of current user when logged in" do
    setup [:insert_tweak, :log_in, :request_show_tweak]

    test "displays the tweak's title", context do
      title =
        context.conn
        |> html_response(:ok)
        |> find("main h3")

      assert text(title) == context.tweak.title
    end

    test "displays the tweak's code", context do
      code =
        context.conn
        |> html_response(:ok)
        |> find("code")

      assert text(code) == context.tweak.code
    end

    test "displays the tweak's description", context do
      description =
        context.conn
        |> html_response(:ok)
        |> find(".tweak-description")

      assert text(description) == context.tweak.description
    end

    test "shows the edit button", context do
      assert has_selector?(html_response(context.conn, :ok), "a#edit-button")
    end
  end

  describe "show tweak of different user when logged in" do
    setup [:insert_tweak, :insert_user, :log_in, :request_user, :request_show_tweak]

    test "displays the tweak's title", context do
      title =
        context.conn
        |> html_response(:ok)
        |> find("main h3")

      assert text(title) == context.tweak.title
    end

    test "displays the tweak's code", context do
      code =
        context.conn
        |> html_response(:ok)
        |> find("code")

      assert text(code) == context.tweak.code
    end

    test "displays the tweak's description", context do
      description =
        context.conn
        |> html_response(:ok)
        |> find(".tweak-description")

      assert text(description) == context.tweak.description
    end

    test "does not show the edit button", context do
      refute has_selector?(html_response(context.conn, :ok), "a#edit-button")
    end
  end
end
