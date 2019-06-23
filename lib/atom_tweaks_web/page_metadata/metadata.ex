defprotocol AtomTweaksWeb.PageMetadata.Metadata do
  @moduledoc """
  Defines the metadata protocol.

  To define an implementation for this protocol for a type, one must return a representation of that
  type as an item or list of metadata. A single item of metadata is a keyword list of
  attribute/value pairs intended to be rendered on an HTML `meta` tag. Multiple items of metadata
  can be returned as a list of keyword lists.

  ## Examples

  The metadatum:

  ```
  [property: "og:title", content: "Some title"]
  ```

  becomes the HTML:

  ```html
  <meta property="og:title" content="Some title" />
  ```

  The metadata:

  ```
  [
    [property: "og:title", content: "Some title"],
    [property: "og:description", content: "A much longer description"]
  ]
  ```

  becomes the HTML:

  ```html
  <meta property="og:title" content="Some title" />
  <meta property="og:description" content="A much longer description" />
  ```
  """

  @doc """
  Gets the page metadata for `record`.
  """
  def to_metadata(record)
end

defimpl AtomTweaksWeb.PageMetadata.Metadata, for: [Keyword, List] do
  def to_metadata(keyword_or_list), do: keyword_or_list
end
