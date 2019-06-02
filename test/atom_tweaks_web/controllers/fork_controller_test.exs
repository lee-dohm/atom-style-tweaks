defmodule AtomTweaksWeb.ForkControllerTest do
  use AtomTweaksWeb.ConnCase

  describe "list forks for a tweak that isn't forked" do
    setup [:insert_tweak, :request_forks]

    test "displays a blankslate element", context do
      blankslate_title =
        context.conn
        |> html_response(:ok)
        |> find(".blankslate h3")

      assert text(blankslate_title) == "No forks of this tweak"
    end
  end

  describe "list forks for a tweak that has been forked" do
    setup [:insert_user_with_tweaks, :fork_tweak, :request_forks]

    test "displays the forked tweak", context do
      fork_title =
        context.conn
        |> html_response(:ok)
        |> find("a.title")

      assert text(fork_title) == context.forked_tweak.title
    end
  end
end
