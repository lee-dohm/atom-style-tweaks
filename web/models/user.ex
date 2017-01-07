defmodule AtomStyleTweaks.User do
  use AtomStyleTweaks.Web, :model

  schema "users" do
    field :name, :string
    field :site_admin, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :site_admin])
    |> validate_required([:name, :site_admin])
    |> unique_constraint(:name)
  end
end
