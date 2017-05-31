defmodule AtomStyleTweaks.TweakController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.ErrorView
  alias AtomStyleTweaks.Tweak
  alias AtomStyleTweaks.User

  require Logger

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user] || :guest]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, _, :guest) do
    conn
    |> put_status(:unauthorized)
    |> render(ErrorView, :"401", %{message: "Not logged in"})
  end

  def create(conn, %{"name" => name}, %{name: other_name}) when name !== other_name do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, :"404", %{message: "User \"#{name}\" not found"})
  end

  def create(conn, %{"name" => name, "tweak" => tweak_params}, _) do
    case Repo.get_by(User, name: name) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(ErrorView, "404.html", %{message: "User \"#{name}\" not found"})
      user ->
        params = Map.merge(tweak_params, %{"created_by" => user.id})
        changeset = Tweak.changeset(%Tweak{}, params)

        case Repo.insert(changeset) do
          {:ok, tweak} -> redirect(conn, to: tweak_path(conn, :show, name, tweak.id))
          {:error, changeset} ->
            conn
            |> render("new.html", changeset: changeset, name: name, errors: changeset.errors)
        end
    end
  end

  def delete(conn, _params, _current_user) do
    conn
  end

  def edit(conn, params = %{"name" => name, "id" => id}, _current_user) do
    tweak = Tweak
            |> Repo.get(id)
            |> Repo.preload([:user])

    changeset = Tweak.changeset(%Tweak{})

    render(conn, "edit.html", changeset: changeset, name: name, tweak: tweak, errors: params["errors"])
  end

  def new(conn, params = %{"name" => name}, _current_user) do
    changeset = Tweak.changeset(%Tweak{})

    render(conn, "new.html", changeset: changeset, name: name, errors: params["errors"])
  end

  def show(conn, %{"name" => name, "id" => id}, _current_user) do
    tweak = Tweak
            |> Repo.get(id)
            |> Repo.preload([:user])

    render(conn, "show.html", name: name, tweak: tweak)
  end

  def update(conn, %{"name" => name, "id" => id, "tweak" => tweak_params}, _current_user) do
    tweak = Repo.get(Tweak, id)
    changeset = Tweak.changeset(tweak, tweak_params)

    case Repo.update(changeset) do
      {:ok, _style} ->
        conn
        |> redirect(to: tweak_path(conn, :show, name, id))
      {:error, changeset} ->
        conn
        |> render("edit.html", name: name, tweak: tweak, changeset: changeset, errors: changeset.errors)
    end
  end
end
