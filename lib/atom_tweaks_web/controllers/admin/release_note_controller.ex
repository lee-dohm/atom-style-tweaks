defmodule AtomTweaksWeb.Admin.ReleaseNoteController do
  @moduledoc """
  Handles all admin release notes resources.
  """

  use AtomTweaksWeb, :controller

  alias AtomTweaks.Releases
  alias AtomTweaks.Releases.Note

  def create(conn, %{"note" => note_params}) do
    %Note{}
    |> Note.changeset(note_params)
    |> Repo.insert()
    |> case do
      {:ok, note} -> redirect(conn, to: Routes.admin_release_note_path(conn, :show, note))
      {:error, changeset} -> render(conn, :new, changeset: changeset)
    end
  end

  @doc """
  Displays the edit form for a release note.
  """
  def edit(conn, %{"id" => id}) do
    note = Releases.get_note!(id)
    changeset = Releases.change_note(note)

    render(conn, "edit.html", changeset: changeset, note: note)
  end

  @doc """
  Renders the list of release notes.
  """
  def index(conn, _params) do
    notes = Releases.list_notes()

    render(conn, "index.html", notes: notes)
  end

  @doc """
  Renders the new form for a release note.
  """
  def new(conn, _params) do
    changeset = Releases.change_note(%Note{})

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Renders the release note with the given `id`.
  """
  def show(conn, %{"id" => id}) do
    note = Releases.get_note!(id)

    render(conn, "show.html", note: note)
  end

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
