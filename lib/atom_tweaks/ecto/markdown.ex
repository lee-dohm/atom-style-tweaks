defmodule AtomTweaks.Ecto.Markdown do
  @moduledoc """
  An `Ecto.Type` that handles the conversion between a Markdown-formatted string in the database and
  a `AtomTweaks.Markdown` struct in memory.

  Use this as the type of the database field in the schema:

  ```
  defmodule AtomTweaks.Tweaks.Tweak do
    use Ecto.Schema

    schema "tweaks" do
      field :title, :string
      field :code, :string
      field :type, :string
      field :description, AtomTweaks.Ecto.Markdown
      belongs_to :user, AtomTweaks.Accounts.User, foreign_key: :created_by, type: :binary_id

      timestamps()
    end
  end
  ```

  All other references in the codebase should be to the `AtomTweaks.Markdown` module. See that
  module's documentation on how it is used.

  **See:** [Beyond Functions in Elixir: Refactoring for Maintainability][beyond-functions] for
  details on this pattern.

  [beyond-functions]: https://blog.usejournal.com/beyond-functions-in-elixir-refactoring-for-maintainability-5c73daba77f3
  """
  @behaviour Ecto.Type

  @doc """
  Returns the underlying schema type for the custom type.

  See: `c:Ecto.Type.type/0`
  """
  @impl Ecto.Type
  def type, do: :string

  @doc """
  Casts the given input to the custom type.

  See: `c:Ecto.Type.cast/1`
  """
  @impl Ecto.Type
  def cast(binary) when is_binary(binary) do
    {:ok, %AtomTweaks.Markdown{text: binary}}
  end

  def cast(markdown = %AtomTweaks.Markdown{}), do: {:ok, markdown}
  def cast(_other), do: :error

  @doc """
  Loads the given term into a custom type.

  See: `c:Ecto.Type.load/1`
  """
  @impl Ecto.Type
  def load(binary) when is_binary(binary) do
    {:ok, %AtomTweaks.Markdown{text: binary, html: AtomTweaks.Markdown.to_html(binary)}}
  end

  def load(_other), do: :error

  @doc """
  Dumps the given term into an Ecto native type.

  See: `c:Ecto.Type.dump/1`
  """
  @impl Ecto.Type
  def dump(%AtomTweaks.Markdown{text: binary}) when is_binary(binary) do
    {:ok, binary}
  end

  def dump(binary) when is_binary(binary), do: {:ok, binary}
  def dump(_other), do: :error
end
