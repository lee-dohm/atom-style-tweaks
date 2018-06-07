defmodule AtomTweaksWeb.ObsoleteRouteControllerTest do
  use AtomTweaksWeb.ConnCase

  setup :insert_tweak

  test "long tweak paths get redirected to short tweak paths", context do
    conn = get(context.conn, "/users/#{context.user.name}/tweaks/#{context.tweak.id}")

    assert redirected_to(conn, :found) == "/tweaks/#{context.tweak.id}"
  end
end
