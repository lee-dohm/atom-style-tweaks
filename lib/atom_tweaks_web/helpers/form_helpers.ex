defmodule AtomTweaksWeb.FormHelpers do
  @moduledoc """
  Functions for building HTML forms, specifically designed to work with
  [GitHub Primer](https://primer.style).
  """
  use Phoenix.HTML

  alias Phoenix.HTML.Form

  alias AtomTweaks.Markdown
  alias AtomTweaksWeb.ErrorHelpers

  @doc """
  Displays the appropriate input control for the given field.

  ## Options

  * `:using` -- override the built-in selection of input field based on data type. Can be any of the
    `Phoenix.HTML.Form` input function names or the following special values:
      * `:markdown` -- displays a specially-formatted `textarea` suitable for entering or editing
        Markdown text
      * `:tweak_type` -- displays a drop-down list of available `AtomTweaks.Tweaks.Tweak` types

  See:
  [Dynamic forms with Phoenix](http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/)
  """
  @spec input(Phoenix.HTML.FormData.t(), atom, keyword) :: Phoenix.HTML.safe()
  def input(form, field, options \\ []) do
    type = options[:using] || Form.input_type(form, field)

    wrapper_opts = [class: "form-group #{error_class(form, field)}"]
    label_opts = []

    input_opts =
      options
      |> Keyword.split([:class, :placeholder])
      |> Tuple.to_list()
      |> hd()
      |> Keyword.update(:class, "form-control", &"form-control #{&1}")

    content_tag :dl, wrapper_opts do
      label =
        content_tag :dt do
          label(form, humanize(field), label_opts)
        end

      input =
        content_tag :dd do
          input(type, form, field, input_opts)
        end

      error = error_tag(form, field) || ""

      [label, input, error]
    end
  end

  defp input(:markdown, form, field, input_opts) do
    content =
      case Form.input_value(form, field) do
        nil -> nil
        %Markdown{} = markdown -> markdown.text
        value -> value
      end

    opts =
      input_opts
      |> Keyword.merge(id: Form.input_id(form, field), name: Form.input_name(form, field))
      |> Keyword.put(:class, (input_opts[:class] || "") <> " image-drop")

    content_tag(:textarea, "#{content}\n", opts)
  end

  defp input(:tweak_type, form, field, _input_opts) do
    selected = Form.input_value(form, field)

    select(
      form,
      field,
      [Init: "init", Style: "style"],
      prompt: "Select tweak type",
      selected: selected
    )
  end

  defp input(type, form, field, input_opts) do
    apply(Form, type, [form, field, input_opts])
  end

  defp error_class(form, field) do
    cond do
      !form.source.action -> ""
      form.errors[field] -> "errored"
      true -> ""
    end
  end

  defp error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag :dd, class: "error" do
        ErrorHelpers.translate_error(error)
      end
    end)
  end
end
