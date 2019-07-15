defmodule AtomTweaksWeb.Admin.RootView do
  @moduledoc """
  View functions for the root of the admin page space.
  """

  use AtomTweaksWeb, :view

  alias AtomTweaks.Logs.Entry

  @doc """
  Renders an `AtomTweaks.Logs.Entry` value field.
  """
  def render_entry_value(entry = %Entry{}) do
    content_tag(:pre) do
      content_tag(:code, inspect(entry.value, limit: :infinity, pretty: true))
    end
  end
end
