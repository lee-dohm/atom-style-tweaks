defmodule AtomStyleTweaks.UserController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Style
  alias AtomStyleTweaks.User

  def show(conn, %{"name" => name}) do
    case Repo.get_by(User, name: name) do
      nil -> not_found(conn)
      user ->
        styles = Repo.all(from s in Style, where: s.created_by == ^user.id)

        conn
        |> assign(:styles, styles)
        |> assign(:user, user)
        |> render("show.html")
    end
  end

  defp not_found(conn) do
    conn
    |> put_status(:not_found)
    |> render(AtomStyleTweaks.ErrorView, "404.html")
  end
end
