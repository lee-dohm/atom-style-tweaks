defmodule AtomStyleTweaks.Style do
  use AtomStyleTweaks.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "styles" do
    field :title, :string
    field :code, :string
    belongs_to :user, AtomStyleTweaks.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :code])
    |> validate_required([:title, :code])
  end
end
