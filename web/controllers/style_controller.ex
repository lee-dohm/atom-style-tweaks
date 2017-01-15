defmodule AtomStyleTweaks.StyleController do
  use AtomStyleTweaks.Web, :controller

  alias AtomStyleTweaks.Style
  alias AtomStyleTweaks.User

  require Logger

  def create(conn, %{"name" => name, "style" => style_params}) do
    user = Repo.get_by!(User, name: name)
    params = Map.merge(style_params, %{"created_by" => user.id})
    changeset = Style.changeset(%Style{}, params)

    case Repo.insert(changeset) do
      {:ok, style} -> redirect(conn, to: style_path(conn, :show, name, style.id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, format_errors(changeset.errors))
        |> render("new.html", changeset: changeset, name: name)
    end
  end

  def delete(conn, params) do
    conn
  end

  def new(conn, %{"name" => name}) do
    changeset = Style.changeset(%Style{})

    render(conn, "new.html", changeset: changeset, name: name)
  end

  def show(conn, %{"name" => name, "id" => id}) do
    style = Repo.get(Style, id) |> Repo.preload([:user])

    render(conn, "show.html", name: name, style: style)
  end

  def update(conn, params) do
    conn
  end

  defp format_error({field, {message, _}}) do
    "Field #{field} #{message}"
  end

  defp format_errors(errors), do: format_errors(errors, [])

  defp format_errors([], formatted), do: Enum.reverse(formatted)
  defp format_errors([error | rest], formatted) do
    format_errors(rest, [format_error(error) | formatted])
  end
end
