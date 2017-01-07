defmodule AtomStyleTweaks.PageControllerTest do
  use AtomStyleTweaks.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Atom Style Tweaks"
  end
end
