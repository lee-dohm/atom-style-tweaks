defmodule AtomStyleTweaksWeb.Model.Helpers do
  def error(field, message, validation), do: [{field, {message, [validation: validation]}}]
  def required_error(field), do: error(field, "can't be blank", :required)
  def inclusion_error(field), do: error(field, "is invalid", :inclusion)
end
