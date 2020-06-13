defmodule AtomTweaksWeb.Admin.ReleaseNoteController do
  @moduledoc """
  Handles all admin release notes resource routes.
  """

  use AtomTweaksWeb, :controller

  alias AtomTweaks.Releases
  alias AtomTweaks.Releases.Note

  @doc """
  Creates a new release note.
  """
  @spec create(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def create(conn, params)

  def create(conn, %{"note" => note_params}) do
    %Note{}
    |> Note.changeset(note_params)
    |> Repo.insert()
    |> case do
      {:ok, note} -> redirect(conn, to: Routes.admin_release_note_path(conn, :show, note))
      {:error, changeset} -> render(conn, :new, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> Releases.get_note!()
    |> Releases.delete_note()
    |> case do
      {:ok, note} -> redirect(conn, to: Routes.admin_release_note_path(conn, :index))
      {:error, changeset} -> render(conn, :edit, changeset: changeset)
    end
  end

  @doc """
  Displays the edit form for a release note.
  """
  @spec edit(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def edit(conn, params)

  def edit(conn, %{"id" => id}) do
    note = Releases.get_note!(id)
    changeset = Releases.change_note(note)

    render(conn, "edit.html", changeset: changeset, note: note)
  end

  @doc """
  Renders the list of release notes.
  """
  @spec index(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def index(conn, _params) do
    notes = Releases.list_notes()

    render(conn, "index.html", notes: notes)
  end

  @doc """
  Renders the new form for a release note.
  """
  @spec new(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Releases.change_note(%Note{})

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Renders the release note with the given `id`.
  """
  @spec show(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def show(conn, params)

  def show(conn, %{"id" => id}) do
    note = Releases.get_note!(id)

    render(conn, "show.html", note: note)
  end

  @doc """
  Updates a release note.
  """
  @spec update(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def update(conn, params)

  def update(conn, %{"id" => id, "note" => note_params}) do
    note = Releases.get_note!(id)

    note
    |> Note.changeset(note_params)
    |> Repo.update()
    |> case do
      {:ok, note} ->
        redirect(conn, to: Routes.admin_release_note_path(conn, :show, note))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, note: note, errors: changeset.errors)
    end
  end
end
