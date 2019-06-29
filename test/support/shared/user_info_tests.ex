defmodule AtomTweaksWeb.Shared.UserInfoTests do
  @moduledoc """
  Shared tests for the user info block on user pages.

  ## Examples

  ```
  use AtomTweaksWeb.Shared.UserInfoTests
  ```
  """

  defmacro __using__(_options) do
    quote do
      test "displays the user's avatar", context do
        avatar =
          context.conn
          |> html_response(:ok)
          |> find("img.avatar")

        assert avatar
      end

      test "displays the user's name", context do
        user_name =
          context.conn
          |> html_response(:ok)
          |> find("#user-info-block h2")

        assert text(user_name) == context.user.name
      end

      test "displays the link to the user's GitHub profile", context do
        github_link =
          context.conn
          |> html_response(:ok)
          |> find("#user-info-block a#user-github-link")

        assert attribute(github_link, "href") == ["https://github.com/#{context.user.name}"]
      end

      test "displays the staff badge if the user is a site admin", context do
        if context.user.site_admin do
          staff_badge =
            context.conn
            |> html_response(:ok)
            |> find("#user-info-block span#staff-badge")

          assert staff_badge
        end
      end
    end
  end
end
