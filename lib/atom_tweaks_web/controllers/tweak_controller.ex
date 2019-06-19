defmodule AtomTweaksWeb.TweakController do
  @moduledoc """
  Handles requests for tweak records.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Tweaks
  alias AtomTweaks.Tweaks.Tweak
  alias AtomTweaksWeb.PageMetadata
  alias AtomTweaksWeb.WrongUserError

  require Logger

  plug(:ensure_authenticated_user when action in [:create, :edit, :new])

  @doc """
  Creates a new tweak with the given parameters.
  """
  @spec create(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def create(conn, params)

  def create(conn, %{"tweak" => tweak_params}) do
    current_user = conn.assigns.current_user
    params = Map.merge(tweak_params, %{"created_by" => current_user.id})
    changeset = Tweak.changeset(%Tweak{}, params)

    case Repo.insert(changeset) do
      {:ok, tweak} -> redirect(conn, to: Routes.tweak_path(conn, :show, tweak))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end

  @doc """
  Deletes the given tweak.

  **Not implemented.**
  """
  @spec delete(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def delete(conn, _params) do
    conn
  end

  @doc """
  Displays the edit tweak form.
  """
  @spec edit(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def edit(conn, params)

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user

    tweak =
      Tweak
      |> Repo.get(id)
      |> Repo.preload([:user])

    if current_user.id != tweak.user.id do
      raise WrongUserError, conn: conn, current_user: current_user, resource_owner: tweak.user
    end

    changeset = Tweak.changeset(tweak)

    render(
      conn,
      "edit.html",
      changeset: changeset,
      tweak: tweak
    )
  end

  @doc """
  Displays the new tweak form.
  """
  @spec new(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def new(conn, params)

  def new(conn, _params) do
    changeset = Tweaks.change_tweak(%Tweak{})

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Displays the given tweak.
  """
  @spec show(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def show(conn, params)

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user

    tweak =
      Tweak
      |> Repo.get(id)
      |> Repo.preload(forked_from: [:user], stargazers: [], user: [])

    fork_count = Tweaks.count_forks(tweak)
    starred = Tweaks.is_starred?(tweak, current_user)

    conn
    |> PageMetadata.add(Tweak.to_metadata(tweak))
    |> render("show.html", fork_count: fork_count, starred: starred, tweak: tweak)
  end

  @doc """
  Updates a tweak with the given parameters.
  """
  @spec update(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def update(conn, params)

  def update(conn, %{"id" => id, "tweak" => tweak_params}) do
    tweak = Tweaks.get_tweak!(id)
    changeset = Tweak.changeset(tweak, tweak_params)

    case Repo.update(changeset) do
      {:ok, tweak} ->
        redirect(conn, to: Routes.tweak_path(conn, :show, tweak))

      {:error, changeset} ->
        render(
          conn,
          "edit.html",
          name: tweak.user.name,
          tweak: tweak,
          changeset: changeset,
          errors: changeset.errors
        )
    end
  end
end
