defmodule AtomStyleTweaks.SharedHelpers do
  @moduledoc """
  Helper functions for rendering shared templates.
  """

  import Phoenix.View, only: [render: 3]
  use Phoenix.HTML

  def render_shared(template_name, assigns \\ []) do
    render(AtomStyleTweaks.SharedView, template_name, assigns)
  end
end
