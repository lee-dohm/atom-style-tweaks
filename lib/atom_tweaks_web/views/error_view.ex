defmodule AtomTweaksWeb.ErrorView do
  @doc """
  View functions for HTTP error states.
  """
  use AtomTweaksWeb, :view

  @doc """
  Renders the page for the given template.

  Since we don't have fancy error pages yet, we're just rendering the text of the status code.
  """
  def render("404.html", _assigns), do: "Page not found"
  def render("422.html", _assigns), do: "Unprocessable entity"
  def render("500.html", _assigns), do: "Internal server error"

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render("500.html", assigns)
  end
end
