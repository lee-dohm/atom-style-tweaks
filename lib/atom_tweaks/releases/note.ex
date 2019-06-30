defmodule AtomTweaks.Releases.Note do
  @moduledoc """
  Represents a release note record.

  ## Fields

  * `description` - Markdown text of the note
  * `detail_url` - URL of where to get more details
  * `title` - Title of the release note
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias AtomTweaks.Ecto.Markdown

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notes" do
    field(:description, Markdown)
    field(:detail_url, :string)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :detail_url, :description])
    |> validate_required([:title, :detail_url, :description])
  end
end
