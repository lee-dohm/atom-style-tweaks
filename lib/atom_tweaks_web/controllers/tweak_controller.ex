defmodule AtomTweaksWeb.TweakController do
  use AtomTweaksWeb, :controller

  alias AtomTweaksWeb.ErrorView
  alias AtomTweaksWeb.PageMetadata
  alias AtomTweaks.Tweak
  alias AtomTweaks.User

  require Logger

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user] || :guest]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, _, :guest), do: render_error(conn, :unauthorized)

  def create(conn, %{"user_id" => name}, %{name: other_name}) when name !== other_name do
    render_error(conn, :not_found, "User \"#{name}\" not found")
  end

  def create(conn, %{"user_id" => name, "tweak" => tweak_params}, _) do
    case Repo.get_by(User, name: name) do
      nil ->
        render_error(conn, :not_found, "User \"#{name}\" not found")

      user ->
        params = Map.merge(tweak_params, %{"created_by" => user.id})
        changeset = Tweak.changeset(%Tweak{}, params)

        case Repo.insert(changeset) do
          {:ok, tweak} ->
            redirect(conn, to: user_tweak_path(conn, :show, name, tweak.id))

          {:error, changeset} ->
            conn
            |> render("new.html", changeset: changeset, name: name, errors: changeset.errors)
        end
    end
  end

  def delete(conn, _params, _current_user) do
    conn
  end

  def edit(conn, _, :guest), do: render_error(conn, :unauthorized)

  def edit(conn, %{"user_id" => name}, %{name: other_name}) when name !== other_name do
    render_error(conn, :not_found, "User \"#{name}\" not found")
  end

  def edit(conn, params = %{"user_id" => name, "id" => id}, _current_user) do
    tweak =
      Tweak
      |> Repo.get(id)
      |> Repo.preload([:user])

    changeset = Tweak.changeset(tweak)

    render(
      conn,
      "edit.html",
      changeset: changeset,
      name: name,
      tweak: tweak,
      errors: params["errors"]
    )
  end

  def new(conn, _, :guest), do: render_error(conn, :unauthorized)

  def new(conn, %{"user_id" => name}, %{name: other_name}) when name !== other_name do
    render_error(conn, :not_found, "User \"#{name}\" not found")
  end

  def new(conn, params = %{"user_id" => name}, _current_user) do
    case Repo.get_by(User, name: name) do
      nil ->
        render_error(conn, :not_found, "User \"#{name}\" not found")

      _ ->
        changeset = Tweak.changeset(%Tweak{})

        render(conn, "new.html", changeset: changeset, name: name, errors: params["errors"])
    end
  end

  def show(conn, %{"user_id" => name, "id" => id}, _current_user) do
    tweak =
      Tweak
      |> Repo.get(id)
      |> Repo.preload([:user])

    conn
    |> PageMetadata.add(Tweak.to_metadata(tweak))
    |> render("show.html", name: name, tweak: tweak)
  end

  def update(conn, %{"user_id" => name, "id" => id, "tweak" => tweak_params}, _current_user) do
    tweak = Repo.get(Tweak, id)
    changeset = Tweak.changeset(tweak, tweak_params)

    case Repo.update(changeset) do
      {:ok, _tweak} ->
        conn
        |> redirect(to: user_tweak_path(conn, :show, name, id))

      {:error, changeset} ->
        conn
        |> render(
          "edit.html",
          name: name,
          tweak: tweak,
          changeset: changeset,
          errors: changeset.errors
        )
    end
  end

  defp render_error(conn, :unauthorized) do
    conn
    |> put_status(:unauthorized)
    |> render(ErrorView, :"401", %{message: "Not logged in"})
  end

  defp render_error(conn, :not_found, message) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, :"404", %{message: message})
  end
end
