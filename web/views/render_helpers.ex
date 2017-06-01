defmodule AtomStyleTweaks.RenderHelpers do
  @moduledoc """
  Helper functions for rendering templates.
  """
  import Phoenix.View

  def render_if(value, view, template, assigns) when not is_boolean(value) do
    # credo:disable-for-next-line Credo.Check.Refactor.DoubleBooleanNegation
    render_if(!!value, view, template, assigns)
  end

  def render_if(true, view, template, assigns), do: render(view, template, assigns)
  def render_if(_, _, _, _), do: nil

  def render_many_or_blank(enumerable, view, many_template, blank_template, assigns) do
    if Enum.count(enumerable) == 0 do
      render(view, blank_template, assigns)
    else
      render_many(enumerable, view, many_template, assigns)
    end
  end
end
