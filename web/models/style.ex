defmodule AtomStyleTweaks.Style do
  use AtomStyleTweaks.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "styles" do
    field :title, :string
    field :code, :string
    belongs_to :user, AtomStyleTweaks.User, foreign_key: :created_by, type: :binary_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :code, :created_by])
    |> validate_required([:title, :code, :created_by])
  end
end
