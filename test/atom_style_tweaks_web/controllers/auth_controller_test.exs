defmodule AtomStyleTweaksWeb.AuthController.Test do
  use AtomStyleTweaksWeb.ConnCase

  test "index redirects to the GitHub authorization URL" do
    conn = build_conn()
    conn = get(conn, auth_path(conn, :index))

    assert redirected_to(conn) =~ "https://github.com/login/oauth/authorize"
  end

  test "index saves the return to path in the session if it is supplied" do
    conn = build_conn()
    conn = get(conn, auth_path(conn, :index, %{"from" => "/foo/bar/baz"}))

    assert get_session(conn, :return_to) == "/foo/bar/baz"
  end
end
