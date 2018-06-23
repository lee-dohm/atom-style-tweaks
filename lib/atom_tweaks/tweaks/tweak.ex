defmodule AtomTweaks.Tweaks.Tweak do
  @moduledoc """
  Represents a tweak.
  """
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias AtomTweaks.Accounts.User
  alias AtomTweaks.Ecto.Markdown
  alias AtomTweaks.Tweaks.Star
  alias AtomTweaks.Tweaks.Tweak

  @type t :: %Tweak{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tweaks" do
    field(:title, :string)
    field(:code, :string)
    field(:type, :string)
    field(:description, Markdown)

    belongs_to(:user, User, foreign_key: :created_by, type: :binary_id)
    belongs_to(:forked_from, Tweak, foreign_key: :parent, type: :binary_id)

    has_many(:forks, Tweak, foreign_key: :parent)

    many_to_many(
      :stargazers,
      User,
      join_through: Star,
      on_replace: :delete,
      on_delete: :delete_all
    )

    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :code, :created_by, :type, :description])
    |> validate_required([:title, :code, :created_by, :type])
    |> validate_inclusion(:type, ["init", "style"])
  end

  def by_type(query, type), do: from(t in query, where: t.type == ^type)

  def preload(query), do: from(t in query, preload: [:user])

  def sorted(query), do: from(t in query, order_by: [desc: :inserted_at])

  def to_metadata(tweak) do
    [
      [property: "og:title", content: tweak.title],
      [property: "og:description", content: tweak.code]
    ]
  end
end
