defmodule AtomStyleTweaks.UserController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Tweak
  alias AtomStyleTweaks.User

  def show(conn, %{"name" => name}) do
    case Repo.get_by(User, name: name) do
      nil -> not_found(conn)
      user ->
        tweaks = Repo.all(from t in Tweak, where: t.created_by == ^user.id, preload: [:user])

        conn
        |> assign(:tweaks, tweaks)
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
