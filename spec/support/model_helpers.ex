defmodule AtomStyleTweaksWeb.Model.Helpers do
  def cast_error(field, type), do: error(field, "is invalid", [type: type, validation: :cast])

  def error(field, message, validation) when is_atom(validation) do
    [{field, {message, [validation: validation]}}]
  end

  def error(field, message, validation) when is_list(validation) do
    [{field, {message, validation}}]
  end

  def inclusion_error(field), do: error(field, "is invalid", :inclusion)

  def required_error(field), do: error(field, "can't be blank", :required)
end
