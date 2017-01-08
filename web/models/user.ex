defmodule AtomStyleTweaks.User do
  use AtomStyleTweaks.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    field :site_admin, :boolean, default: false
    field :avatar_url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :site_admin, :avatar_url])
    |> validate_required([:name, :site_admin, :avatar_url])
    |> unique_constraint(:name)
  end
end
