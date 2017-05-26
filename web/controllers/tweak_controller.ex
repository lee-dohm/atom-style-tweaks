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
        |> put_flash(:error, format_errors(changeset.errors))
        |> render("new.html", changeset: changeset, name: name)
    end
  end

  def delete(conn, _params) do
    conn
  end

  def edit(conn, %{"name" => name, "id" => id}) do
    tweak = Tweak
            |> Repo.get(id)
            |> Repo.preload([:user])

    changeset = Tweak.changeset(%Tweak{})

    render(conn, "edit.html", changeset: changeset, name: name, tweak: tweak)
  end

  def new(conn, %{"name" => name}) do
    changeset = Tweak.changeset(%Tweak{})

    render(conn, "new.html", changeset: changeset, name: name)
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
        render(conn, "edit.html", name: name, tweak: tweak, changeset: changeset)
    end
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
