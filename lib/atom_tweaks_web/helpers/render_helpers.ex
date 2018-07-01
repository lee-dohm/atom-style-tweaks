defmodule AtomTweaksWeb.RenderHelpers do
  @moduledoc """
  Helper functions for rendering templates.
  """
  use Phoenix.HTML

  require Logger

  import Phoenix.View

  alias AtomTweaks.Tweaks.Tweak

  @doc """
  Renders the code for the given `tweak`.
  """
  @spec render_code(Tweak.t()) :: Phoenix.HTML.safe()
  def render_code(tweak) do
    content_tag(:pre) do
      content_tag(:code, tweak.code, class: code_class_for(tweak), id: "code")
    end
  end

  @doc """
  Renders the template if the condition is truthy.
  """
  @spec render_if(boolean, String.t(), map) :: Phoenix.HTML.safe()
  def render_if(condition, template, assigns = %{conn: conn}) do
    render_if(condition, conn.private.phoenix_view, template, assigns)
  end

  @doc """
  Renders the template on the view if the condition is truthy.
  """
  @spec render_if(boolean, module, String.t(), map) :: Phoenix.HTML.safe()
  def render_if(condition, view, template, assigns)

  def render_if(nil, _, _, _), do: nil
  def render_if(false, _, _, _), do: nil
  def render_if(_, view, template, assigns), do: render(view, template, assigns)

  @doc """
  Renders the many template if there are any items in `enumerable`, otherwise the blank template.

  Both templates must belong to the same view module.
  """
  @spec render_many_or_blank(Enum.t(), String.t(), String.t(), map) :: Phoenix.HTML.safe()
  def render_many_or_blank(enumerable, many_template, blank_template, assigns = %{conn: conn}) do
    render_many_or_blank(
      enumerable,
      conn.private.phoenix_view,
      many_template,
      blank_template,
      assigns
    )
  end

  @doc """
  Renders the many template on the view if there are any items in `enumerable`, otherwise the blank
  template.

  Both templates must belong to the same view module.
  """
  @spec render_many_or_blank(Enum.t(), module, String.t(), String.t(), map) :: Phoenix.HTML.safe()
  def render_many_or_blank(enumerable, view, many_template, blank_template, assigns) do
    if Enum.empty?(enumerable) do
      render(view, blank_template, assigns)
    else
      render_many(enumerable, view, many_template, assigns)
    end
  end

  defp code_class_for(%{type: "init"}), do: ""
  defp code_class_for(%{type: "style"}), do: "less"
end
