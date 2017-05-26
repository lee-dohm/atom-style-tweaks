defmodule AtomStyleTweaks.TweakController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Tweak
  alias AtomStyleTweaks.User

  require Logger

  def create(conn, %{"name" => name, "tweak" => tweak_params}) do
    user = Repo.get_by!(User, name: name)
    params = Map.merge(tweak_params, %{"created_by" => user.id})
    changeset = Tweak.changeset(%Tweak{}, params)

    case Repo.insert(changeset) do
      {:ok, tweak} -> redirect(conn, to: tweak_path(conn, :show, name, tweak.id))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset, name: name, errors: changeset.errors)
    end
  end

  def delete(conn, _params) do
    conn
  end

  def edit(conn, params = %{"name" => name, "id" => id}) do
    tweak = Tweak
            |> Repo.get(id)
            |> Repo.preload([:user])

    changeset = Tweak.changeset(%Tweak{})

    render(conn, "edit.html", changeset: changeset, name: name, tweak: tweak, errors: params["errors"])
  end

  def new(conn, params = %{"name" => name}) do
    changeset = Tweak.changeset(%Tweak{})

    render(conn, "new.html", changeset: changeset, name: name, errors: params["errors"])
  end

  def show(conn, %{"name" => name, "id" => id}) do
    tweak = Tweak
            |> Repo.get(id)
            |> Repo.preload([:user])

    render(conn, "show.html", name: name, tweak: tweak)
  end

  def update(conn, %{"name" => name, "id" => id, "tweak" => tweak_params}) do
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
