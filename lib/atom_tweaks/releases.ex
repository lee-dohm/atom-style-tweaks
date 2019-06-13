defmodule AtomTweaks.Releases do
  @moduledoc """
  Operations on and with releases.
  """

  import Ecto.Query, warn: false

  alias AtomTweaks.Releases.Note
  alias AtomTweaks.Repo

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.

  ## Examples

  ```
  iex> change_note(note)
  %Ecto.Changeset{source: %Note{}}
  ```
  """
  def change_note(note = %Note{}) do
    Note.changeset(note, %{})
  end

  @doc """
  Creates a note.

  ## Examples

  ```
  iex> create_note(%{field: value})
  {:ok, %Note{}}
  ```

  ```
  iex> create_note(%{field: bad_value})
  {:error, %Ecto.Changeset{}}
  ```
  """
  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Note.

  ## Examples

  ```
  iex> delete_note(note)
  {:ok, %Note{}}
  ```

  ```
  iex> delete_note(note)
  {:error, %Ecto.Changeset{}}
  ```
  """
  def delete_note(note = %Note{}) do
    Repo.delete(note)
  end

  @doc """
  Gets a single note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

  ```
  iex> get_note!(123)
  %Note{}
  ```

  ```
  iex> get_note!(456)
  ** (Ecto.NoResultsError)
  ```
  """
  def get_note!(id), do: Repo.get!(Note, id)

  @doc """
  Returns the list of notes.

  ## Examples

  ```
  iex> list_notes()
  [%Note{}, ...]
  ```
  """
  def list_notes do
    Repo.all(Note)
  end

  @doc """
  Updates a note.

  ## Examples

  ```
  iex> update_note(note, %{field: new_value})
  {:ok, %Note{}}
  ```

  ```
  iex> update_note(note, %{field: bad_value})
  {:error, %Ecto.Changeset{}}
  ```
  """
  def update_note(note = %Note{}, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end
end
