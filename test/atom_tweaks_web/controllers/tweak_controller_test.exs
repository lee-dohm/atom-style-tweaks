defmodule AtomTweaksWeb.TweakControllerTest do
  use AtomTweaksWeb.ConnCase

  alias AtomTweaks.Tweaks
  alias AtomTweaksWeb.NotLoggedInError

  describe "create tweak when not logged in" do
    setup [:insert_user, :valid_tweak_params]

    test "raises NotLoggedInError", context do
      assert_raise NotLoggedInError, fn ->
        request_create_tweak(context)
      end
    end
  end

  describe "create valid tweak when logged in" do
    setup [:insert_user, :log_in, :valid_tweak_params, :request_create_tweak]

    test "redirects to the created tweak show page", context do
      assert redirected_to(context.conn, :found) =~ "/tweaks"
    end
  end

  describe "create invalid tweak when logged in" do
    setup [:insert_user, :log_in, :invalid_tweak_params, :request_create_tweak]

    test "renders the new tweak template", context do
      assert html_response(context.conn, :ok)
      assert view_template(context.conn) == "new.html"
    end
  end

  describe "new tweak when not logged in" do
    setup [:insert_user]

    test "returns status unauthorized", context do
      assert_raise NotLoggedInError, fn ->
        request_new_tweak(context)
      end
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

  describe "request edit tweak when not logged in" do
    setup [:insert_tweak]

    test "returns status unauthorized", context do
      assert_raise NotLoggedInError, fn ->
        request_edit_tweak(context)
      end
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

      path = tweak_path(context.conn, :show, context.tweak)

      assert attribute(button, "href") == [path]
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

      assert text(description) == context.tweak.description.text
    end

    test "does not show the edit button", context do
      refute has_selector?(html_response(context.conn, :ok), "a#edit-button")
    end

    test "disables the star button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("#star-button")

      assert attribute(button, "disabled") == ["disabled"]
    end

    test "disables the fork button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("#fork-button")

      assert attribute(button, "disabled") == ["disabled"]
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

      assert text(description) == context.tweak.description.text
    end

    test "shows the edit button", context do
      assert has_selector?(html_response(context.conn, :ok), "a#edit-button")
    end

    test "enables the star button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("#star-button")

      assert attribute(button, "disabled") == []
    end

    test "disables the fork button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("#fork-button")

      assert attribute(button, "disabled") == ["disabled"]
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

      assert text(description) == context.tweak.description.text
    end

    test "does not show the edit button", context do
      refute has_selector?(html_response(context.conn, :ok), "a#edit-button")
    end

    test "enables the star button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("#star-button")

      assert attribute(button, "disabled") == []
    end

    test "enables the fork button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find("#fork-button")

      assert attribute(button, "disabled") == []
    end
  end

  describe "update tweak" do
    setup [:insert_tweak]

    test "updates the tweak when given the correct inputs", context do
      tweak_params = params_for(:tweak)

      params = %{
        "user_id" => context.user.name,
        "id" => context.tweak.id,
        "tweak" => tweak_params
      }

      conn = put(context.conn, tweak_path(context.conn, :update, context.tweak), params)
      updated_tweak = Tweaks.get_tweak!(context.tweak.id)

      assert redirected_to(conn, :found) == tweak_path(conn, :show, context.tweak)
      assert updated_tweak.title == tweak_params.title
      assert updated_tweak.description.text == tweak_params.description.text
    end

    test "does not update the tweak when given erroneous inputs", context do
      tweak_params = params_for(:tweak, title: "")

      params = %{
        "user_id" => context.user.name,
        "id" => context.tweak.id,
        "tweak" => tweak_params
      }

      conn = put(context.conn, tweak_path(context.conn, :update, context.tweak), params)
      updated_tweak = Tweaks.get_tweak!(context.tweak.id)

      assert html_response(conn, :ok)
      assert updated_tweak.title != ""
    end
  end
end
