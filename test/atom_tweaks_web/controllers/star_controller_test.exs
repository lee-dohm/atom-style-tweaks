defmodule AtomTweaksWeb.StarControllerTest do
  use AtomTweaksWeb.ConnCase

  setup [:insert_tweak, :insert_star, :request_stars]

  describe "GET index" do
    test "tweaks underline nav is not selected", context do
      response = html_response(context.conn, :ok)
      link = find(response, "a#tweaks-nav.UnderlineNav-item")

      assert text(link) =~ "Tweaks"
    end

    test "tweaks underline nav includes a count", context do
      response = html_response(context.conn, :ok)
      counter = find(response, "#tweaks-nav span.Counter")

      assert text(counter) == "1"
    end

    test "stars underline nav should be selected", context do
      response = html_response(context.conn, :ok)
      link = find(response, "a#stars-nav.UnderlineNav-item.selected")

      assert text(link) =~ "Stars"
    end

    test "stars underline nav includes a count", context do
      response = html_response(context.conn, :ok)
      counter = find(response, "#stars-nav span.Counter")

      assert text(counter) == "1"
    end

    test "starred tweak is listed", context do
      response = html_response(context.conn, :ok)
      links = find(response, "a.Box-row-link.title")

      assert text(links) =~ context.tweak.title
    end
  end
end
