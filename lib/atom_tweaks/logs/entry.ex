defmodule AtomTweaks.Logs.Entry do
  @moduledoc """
  Represents an audit log entry.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "entries" do
    field(:key, :string)
    field(:value, :map)

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
    |> validate_format(:key, ~r/^\S+$/, message: "contains whitespace")
    |> validate_format(:key, ~r/^[^.]+\.[^.]+$/, message: "contains more than one subcategory")
  end
end
