defmodule AtomTweaksWeb.TokenControllerTest do
  use AtomTweaksWeb.ConnCase

  alias AtomTweaksWeb.ForbiddenUserError
  alias AtomTweaksWeb.NotLoggedInError

  describe "index when not logged in" do
    setup [:insert_user]

    test "returns unauthorized", context do
      assert_raise NotLoggedInError, fn ->
        request_user_token_index(context)
      end
    end
  end

  describe "index when logged in as a normal user" do
    setup [:insert_user, :log_in]

    test "returns forbidden", context do
      assert_raise ForbiddenUserError, fn ->
        request_user_token_index(context)
      end
    end
  end

  describe "index when logged in as a site admin viewing another user" do
    setup [:insert_site_admin, :log_in, :insert_user]

    test "returns forbidden", context do
      assert_raise ForbiddenUserError, fn ->
        request_user_token_index(context)
      end
    end
  end

  describe "index when logged in as a site admin with no tokens" do
    setup [:insert_site_admin, :log_in, :request_user_token_index]

    use AtomTweaksWeb.Shared.HeaderTests, logged_in: true
    use AtomTweaksWeb.Shared.FooterTests
    use AtomTweaksWeb.Shared.UserInfoTests

    test "displays a blankslate element", context do
      blankslate =
        context.conn
        |> html_response(:ok)
        |> find(".blankslate")

      assert text(blankslate) == "You haven't created any tokens yet."
    end
  end

  describe "index when logged in as a site admin that has tokens" do
    setup [:insert_site_admin, :log_in, :insert_tokens, :request_user_token_index]

    use AtomTweaksWeb.Shared.HeaderTests, logged_in: true
    use AtomTweaksWeb.Shared.FooterTests
    use AtomTweaksWeb.Shared.UserInfoTests

    test "displays the token descriptions", context do
      titles =
        context.conn
        |> html_response(:ok)
        |> find(".title")

      assert Enum.all?(context.tokens, fn token -> text(titles) =~ token.description end)
    end

    test "displays the token delete buttons", context do
      delete_buttons =
        context.conn
        |> html_response(:ok)
        |> find(".Box-row a")

      assert Enum.all?(context.tokens, fn token ->
               Routes.user_token_path(context.conn, :delete, context.user, token) in attribute(
                 delete_buttons,
                 "href"
               )
             end)
    end
  end

  describe "new when not logged in" do
    setup [:insert_user]

    test "returns unauthorized", context do
      assert_raise NotLoggedInError, fn ->
        request_user_token_new(context)
      end
    end
  end

  describe "new when logged in as a normal user" do
    setup [:insert_user, :log_in]

    test "returns forbidden", context do
      assert_raise ForbiddenUserError, fn ->
        request_user_token_new(context)
      end
    end
  end

  describe "new when logged in as a site admin viewing another user" do
    setup [:insert_site_admin, :log_in, :insert_user]

    test "returns forbidden", context do
      assert_raise ForbiddenUserError, fn ->
        request_user_token_new(context)
      end
    end
  end

  describe "new when logged in as a site admin" do
    setup [:insert_site_admin, :log_in, :request_user_token_new]

    use AtomTweaksWeb.Shared.HeaderTests, logged_in: true
    use AtomTweaksWeb.Shared.FooterTests
    use AtomTweaksWeb.Shared.UserInfoTests

    test "displays the appropriate form", context do
      form =
        context.conn
        |> html_response(:ok)
        |> find("form")

      assert attribute(form, "action") == [
               Routes.user_token_path(context.conn, :create, context.user)
             ]

      assert attribute(form, "method") == ["post"]
    end

    test "displays description label", context do
      label =
        context.conn
        |> html_response(:ok)
        |> find("form label")

      assert attribute(label, "for") == ["token_Description"]
      assert text(label) == "Description"
    end

    test "displays description edit box", context do
      edit =
        context.conn
        |> html_response(:ok)
        |> find("form input#token_description")

      assert attribute(edit, "placeholder") == ["Description"]
      assert attribute(edit, "type") == ["text"]
      assert attribute(edit, "value") == []
    end

    test "displays save token button", context do
      button =
        context.conn
        |> html_response(:ok)
        |> find(".form-actions .btn.btn-primary")

      assert attribute(button, "type") == ["submit"]
      assert text(button) == "Save new token"
    end
  end
end
