defmodule AtomStyleTweaks.StyleController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Style

  def create(conn, %{"name" => name, "style" => style_params}) do
    conn
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
