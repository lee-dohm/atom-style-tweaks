defmodule Support.TestMetadata do
  @moduledoc """
  A structure to test the support for the `AtomTweaksWeb.PageMetadata.Metadata` protocol.
  """

  defstruct [:foo]

  defimpl AtomTweaksWeb.PageMetadata.Metadata do
    def to_metadata(value) do
      [foo: value.foo]
    end
  end
end
