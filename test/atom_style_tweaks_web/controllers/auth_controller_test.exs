defmodule AtomTweaksWeb.AuthControllerTest do
  use AtomTweaksWeb.ConnCase

  describe "GET index" do
    test "redirects to the GitHub authorization URL", context do
      conn = get(context.conn, auth_path(context.conn, :index))

      assert redirected_to(conn, :found) ==
               "https://github.com/login/oauth/authorize?client_id=&redirect_uri=&response_type=code&scope=read%3Aorg"
    end

    test "saves the return to path in the session", context do
      conn = get(context.conn, auth_path(context.conn, :index, %{"from" => "/foo/bar/baz"}))

      assert get_session(conn, :return_to) == "/foo/bar/baz"
    end
  end
end
