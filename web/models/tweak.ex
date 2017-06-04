defmodule AtomStyleTweaks.Tweak do
  @moduledoc """
  Represents a tweak.
  """

  use AtomStyleTweaks.Web, :model

  import Ecto.Query

  alias AtomStyleTweaks.Tweak

  @type t :: %Tweak{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tweaks" do
    field :title, :string
    field :code, :string
    field :type, :string
    belongs_to :user, AtomStyleTweaks.User, foreign_key: :created_by, type: :binary_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :code, :created_by, :type])
    |> validate_required([:title, :code, :created_by, :type])
    |> validate_inclusion(:type, ["init", "style"])
  end

  @doc """
  Filters a query by type.

  ## Examples

      iex> AtomStyleTweaks.Tweak |>
      ...> AtomStyleTweaks.Tweak.by_type("init") |>
      ...> AtomStyleTweaks.Repo.all
      []
  """
  def by_type(query, type), do: from t in query, where: t.type == ^type

  @doc """
  Preloads the associated records in the query results.

  ## Examples

      iex> AtomStyleTweaks.Tweak |>
      ...> AtomStyleTweaks.Tweak.preload |>
      ...> AtomStyleTweaks.Repo.all
      []
  """
  def preload(query), do: from t in query, preload: [:user]

  @doc """
  Sorts the query, by default descending by last updated time.

  ## Examples

      iex> AtomStyleTweaks.Tweak |>
      ...> AtomStyleTweaks.Tweak.sorted |>
      ...> AtomStyleTweaks.Repo.all
      []

      iex> AtomStyleTweaks.Tweak |>
      ...> AtomStyleTweaks.Tweak.sorted(asc: :inserted_at) |>
      ...> AtomStyleTweaks.Repo.all
      []
  """
  def sorted(query), do: from t in query, order_by: [desc: :updated_at]
  def sorted(query, order_by), do: from t in query, order_by: ^order_by
end
