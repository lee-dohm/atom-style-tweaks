defmodule AtomStyleTweaks.SharedHelpers do
  import Phoenix.View, only: [render: 3]
  use Phoenix.HTML

  def render_shared(template_name, assigns \\ []) do
    render(AtomStyleTweaks.SharedView, template_name, assigns)
  end
end
