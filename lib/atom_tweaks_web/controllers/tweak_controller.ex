defmodule AtomTweaksWeb.TweakController do
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Tweaks
  alias AtomTweaks.Tweaks.Tweak
  alias AtomTweaksWeb.ErrorView
  alias AtomTweaksWeb.NotLoggedInError
  alias AtomTweaksWeb.PageMetadata

  require Logger

  @type current_user :: User.t() | atom

  @doc """
  Adds a third argument to every action that contains the current user or the atom `:guest`.

  Runs before all other actions in the controller.
  """
  @spec action(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def action(conn, params)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user] || :guest]
    apply(__MODULE__, action_name(conn), args)
  end

  @doc """
  Creates a new tweak with the given parameters.
  """
  @spec create(Plug.Conn.t(), Map.t(), current_user) :: Plug.Conn.t()
  def create(conn, params, current_user)

  def create(conn, _, :guest), do: raise(NotLoggedInError, conn: conn)

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

  @doc """
  Deletes the given tweak.

  **Not implemented.**
  """
  @spec delete(Plug.Conn.t(), Map.t(), current_user) :: Plug.Conn.t()
  def delete(conn, _params, _current_user) do
    conn
  end

  @doc """
  Displays the edit tweak form.
  """
  @spec edit(Plug.Conn.t(), Map.t(), current_user) :: Plug.Conn.t()
  def edit(conn, params, current_user)

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

  @doc """
  Displays the new tweak form.
  """
  @spec new(Plug.Conn.t(), Map.t(), current_user) :: Plug.Conn.t()
  def new(conn, params, current_user)

  def new(conn, _, :guest), do: render_error(conn, :unauthorized)

  def new(conn, %{"user_id" => name}, %{name: other_name}) when name !== other_name do
    render_error(conn, :not_found, "User \"#{name}\" not found")
  end

  def new(conn, %{"user_id" => name}, _current_user) do
    changeset = Tweaks.change_tweak(%Tweak{})

    render(conn, "new.html", changeset: changeset, name: name)
  end

  @doc """
  Displays the given tweak.
  """
  @spec show(Plug.Conn.t(), Map.t(), current_user) :: Plug.Conn.t()
  def show(conn, params, current_user)

  def show(conn, %{"user_id" => name, "id" => id}, _current_user) do
    tweak =
      Tweak
      |> Repo.get(id)
      |> Repo.preload([:user])

    conn
    |> PageMetadata.add(Tweak.to_metadata(tweak))
    |> render("show.html", name: name, tweak: tweak)
  end

  @doc """
  Updates a tweak with the given parameters.
  """
  @spec update(Plug.Conn.t(), Map.t(), current_user) :: Plug.Conn.t()
  def update(conn, params, current_user)

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
