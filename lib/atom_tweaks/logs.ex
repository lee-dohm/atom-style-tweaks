defmodule AtomTweaks.Logs do
  @moduledoc """
  Operations having to do with the audit log.
  """

  import Ecto.Query, warn: false

  alias AtomTweaks.Logs.Entry
  alias AtomTweaks.Repo

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
  Returns the list of entries.

  ## Options

  * `limit` Limits the number of entries listed (_default:_ 25)
  * `offset` Offset from the first entry to list (_default:_ 0)

  ## Examples

  ```
  iex> list_entries()
  [%Entry{}, ...]
  ```
  """
  def list_entries(options \\ []) do
    limit = Keyword.get(options, :limit, 25)
    offset = Keyword.get(options, :offset, 0)

    Entry
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end
end
