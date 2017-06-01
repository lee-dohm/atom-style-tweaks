defmodule AtomStyleTweaks.RenderHelpers do
  @moduledoc """
  Helper functions for rendering templates.
  """
  import Phoenix.View

  @doc """
  Renders the template if the condition is `true`.
  """
  @spec render_if(boolean, atom, String.t, map) :: Phoenix.HTML.safe
  def render_if(value, view, template, assigns) when not is_boolean(value) do
    # credo:disable-for-next-line Credo.Check.Refactor.DoubleBooleanNegation
    render_if(!!value, view, template, assigns)
  end

  def render_if(true, view, template, assigns), do: render(view, template, assigns)
  def render_if(_, _, _, _), do: nil

  @doc """
  Renders the many template if there are any items in `enumerable`, otherwise the blank template.
  """
  @spec render_many_or_blank(Enum.t, atom, String.t, String.t, map) :: Phoenix.HTML.safe
  def render_many_or_blank(enumerable, view, many_template, blank_template, assigns) do
    if Enum.count(enumerable) == 0 do
      render(view, blank_template, assigns)
    else
      render_many(enumerable, view, many_template, assigns)
    end
  end
end
