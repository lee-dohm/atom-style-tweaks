defmodule AtomStyleTweaks.StyleController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Style
  alias AtomStyleTweaks.User

  def create(conn, %{"name" => name, "style" => style_params}) do
    user = Repo.get_by!(User, name: name)
    params = Map.merge(style_params, %{"user_id" => user.id})
    changeset = Style.changeset(%Style{}, params)

    case Repo.insert(changeset) do
      {:ok, style} ->
        conn
        |> put_flash(:info, "Style created successfully")
        |> redirect(to: style_path(conn, :show, name, style.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, params) do
    conn
  end

  def new(conn, %{"name" => name}) do
    changeset = Style.changeset(%Style{})

    render(conn, "new.html", changeset: changeset, name: name)
  end

  def show(conn, params) do
    conn
  end

  def update(conn, params) do
    conn
  end
end
