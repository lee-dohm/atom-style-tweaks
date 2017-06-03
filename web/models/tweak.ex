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

  def by_type(query, type), do: from t in query, where: t.type == ^type

  def preload(query), do: from t in query, preload: [:user]

  def sorted(query), do: from t in query, order_by: [desc: :updated_at]

  def slugified_title(title) do
    title
    |> String.downcase
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end

  # defimpl Phoenix.Param, for: AtomStyleTweaks.Tweak do
  #   def to_param(%{title: title}) do
  #     Tweak.slugified_title(title)
  #   end
  # end
end
