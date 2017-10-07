defmodule AtomStyleTweaksWeb.Tweak do
  @moduledoc """
  Represents a tweak.
  """

  use AtomStyleTweaksWeb, :model

  alias AtomStyleTweaksWeb.Tweak

  @type t :: %Tweak{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "tweaks" do
    field :title, :string
    field :code, :string
    field :type, :string
    field :description, :string
    belongs_to :user, AtomStyleTweaksWeb.User, foreign_key: :created_by, type: :binary_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :code, :created_by, :type, :description])
    |> validate_required([:title, :code, :created_by, :type])
    |> validate_inclusion(:type, ["init", "style"])
  end

  def by_type(query, type), do: from t in query, where: t.type == ^type

  def preload(query), do: from t in query, preload: [:user]

  def sorted(query), do: from t in query, order_by: [desc: :updated_at]

  def to_metadata(tweak) do
    %{
      "og:title": tweak.title,
      "og:description": tweak.code
    }
  end
end
