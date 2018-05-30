defmodule AtomTweaksWeb.UserController do
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Accounts
  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Tweaks.Tweak

  def show(conn, %{"id" => name}) do
    user = Accounts.get_user!(name)
    tweaks = Repo.all(from(t in Tweak, where: t.created_by == ^user.id, preload: [:user]))

    conn
    |> assign(:tweaks, tweaks)
    |> assign(:user, user)
    |> render("show.html")
  end
end
