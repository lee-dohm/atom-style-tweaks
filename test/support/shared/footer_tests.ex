defmodule AtomTweaksWeb.Shared.FooterTests do
  @moduledoc """
  Shared tests for the common page footer.

  ## Examples

  ```
  use AtomTweaksWeb.Shared.FooterTests
  ```
  """
  defmacro __using__(_options) do
    quote do
      alias AtomTweaksWeb.Router.Helpers, as: Routes

      test "shows the about page link", context do
        link =
          context.conn
          |> html_response(:ok)
          |> find("footer a#about-link")

        assert text(link) == "About"
        assert attribute(link, "href") == [Routes.page_path(context.conn, :about)]
      end

      test "shows the GitHub link", context do
        link =
          context.conn
          |> html_response(:ok)
          |> find("footer a#github-link")

        assert attribute(link, "href") == ["https://github.com/lee-dohm/atom-style-tweaks"]
      end

      test "shows the release notes link", context do
        link =
          context.conn
          |> html_response(:ok)
          |> find("footer a#release-notes-link")

        assert text(link) == "Release notes"
        assert attribute(link, "href") == [Routes.page_path(context.conn, :release_notes)]
      end
    end
  end
end
