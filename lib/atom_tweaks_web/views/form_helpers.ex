defmodule AtomTweaksWeb.FormHelpers do
  @moduledoc """
  Functions for more easily building forms.
  """
  use Phoenix.HTML

  alias AtomTweaksWeb.ErrorHelpers

  def form_group(errors, field, do: block),
    do: form_group(errors_for_field(errors, field), do: block)

  def form_group([], do: block) do
    content_tag(:dl, class: "form-group") do
      content_tag(:dd, block)
    end
  end

  def form_group([error | _], do: block) do
    content_tag(:dl, class: "form-group errored") do
      [
        content_tag(:dd, block),
        content_tag(:dd, ErrorHelpers.translate_error(error), class: "error")
      ]
    end
  end

  defp errors_for_field(nil, _), do: []
  defp errors_for_field(errors, field), do: Keyword.get_values(errors, field)
end
