defmodule AtomStyleTweaks.PageController.Test do
  use AtomStyleTweaks.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Atom Tweaks"
  end
end
