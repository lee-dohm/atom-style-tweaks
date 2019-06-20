defmodule AtomTweaksWeb.Shared.HeaderTests do
  @moduledoc """
  Shared tests for the common page header.

  ## Examples

  When testing the page when logged in:

  ```
  use AtomTweaksWeb.Shared.HeaderTests, logged_in: true
  ```

  When testing the page logged out:

  ```
  use AtomTweaksWeb.Shared.HeaderTests. logged_in: false
  ```
  """

  defmacro __using__(options) do
    if options[:logged_in] do
      quote do
        alias AtomTweaksWeb.Router.Helpers, as: Routes

        test "shows the sign out link", context do
          link =
            context.conn
            |> html_response(:ok)
            |> find("#sign-out")

          assert text(link) == "Sign out"
          assert attribute(link, "href") == [Routes.auth_path(context.conn, :delete)]
        end

        test "shows the current user link", context do
          link =
            context.conn
            |> html_response(:ok)
            |> find("#current-user")

          assert text(link) == context.current_user.name

          assert attribute(link, "href") == [
                   Routes.user_path(context.conn, :show, context.current_user)
                 ]
        end
      end
    else
      quote do
        alias AtomTweaksWeb.Router.Helpers, as: Routes

        test "displays the home page link", context do
          link =
            context.conn
            |> html_response(:ok)
            |> find("a.masthead-logo")

          assert text(link) == "Atom Tweaks"
          assert attribute(link, "href") == [Routes.page_path(context.conn, :index)]
        end

        test "shows the sign in with GitHub button", context do
          button =
            context.conn
            |> html_response(:ok)
            |> find("#sign-in")

          assert text(button) == "Sign in with"
          assert attribute(button, "href") == [Routes.auth_path(context.conn, :index, from: "/")]
        end
      end
    end
  end
end
