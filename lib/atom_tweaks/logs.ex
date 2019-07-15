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

  * `page` Page number of entries to return (_default:_ 1)
  * `per_page` Limits the number of entries listed per page (_default:_ 25, _max:_ 100, _min:_ 1)

  ## Examples

  ```
  iex> list_entries()
  [%Entry{}, ...]
  ```
  """
  def list_entries(options \\ []) do
    per_page = Keyword.get(options, :per_page, 25)
    page = Keyword.get(options, :page, 1)

    limit = if per_page > 100, do: 100, else: per_page
    limit = if per_page < 1, do: 1, else: limit
    offset = (page - 1) * limit

    Entry
    |> order_by([desc: :inserted_at])
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end
end
