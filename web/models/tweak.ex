defmodule AtomStyleTweaks.Tweak do
  @moduledoc """
  Represents a tweak.
  """

  use AtomStyleTweaks.Web, :model

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
    |> validate_inclusion(:type, ["style"])
  end
end
