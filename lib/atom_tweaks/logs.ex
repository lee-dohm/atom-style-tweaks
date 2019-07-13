defmodule AtomTweaks.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias AtomTweaks.Repo

  alias AtomTweaks.Logs.Entry

  @doc """
  Returns the list of entries.

  ## Examples

  ```
  iex> list_entries()
  [%Entry{}, ...]
  ```
  """
  def list_entries do
    Repo.all(Entry)
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

  ```
  iex> get_entry!(123)
  %Entry{}
  ```

  ```
  iex> get_entry!(456)
  ** (Ecto.NoResultsError)
  ```
  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.

  ## Examples

  ```
  iex> create_entry(%{field: value})
  {:ok, %Entry{}}
  ```

  ```
  iex> create_entry(%{field: bad_value})
  {:error, %Ecto.Changeset{}}
  ```
  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entry.

  ## Examples

  ```
  iex> update_entry(entry, %{field: new_value})
  {:ok, %Entry{}}
  ```

  ```
  iex> update_entry(entry, %{field: bad_value})
  {:error, %Ecto.Changeset{}}
  ```
  """
  def update_entry(entry = %Entry{}, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Entry.

  ## Examples

  ```
  iex> delete_entry(entry)
  {:ok, %Entry{}}
  ```

  ```
  iex> delete_entry(entry)
  {:error, %Ecto.Changeset{}}
  ```
  """
  def delete_entry(entry = %Entry{}) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

  ```
  iex> change_entry(entry)
  %Ecto.Changeset{source: %Entry{}}
  ```
  """
  def change_entry(entry = %Entry{}) do
    Entry.changeset(entry, %{})
  end
end
