defmodule AtomStyleTweaks.HtmlMatchers do
  import ExUnit.Assertions

  def find_element(conn, selector) do
    element = conn
              |> decoded_response(200)
              |> Floki.find(selector)

    if element == [], do: nil, else: element
  end

  def has_attribute(nil, _), do: nil

  def has_attribute(element, expected_attribute) do
    assert get_attribute(element, expected_attribute)

    element
  end

  def has_attribute(nil, _, _), do: nil

  def has_attribute(element, attribute, expected_value) do
    assert get_attribute(element, attribute) == expected_value

    element
  end

  def has_text(nil, _), do: nil

  def has_text(element, expected) do
    assert get_text(element) == expected

    element
  end

  def links_to(nil, _), do: nil

  def links_to(element, expected) do
    assert get_href(element) == expected

    element
  end

  def matches_text(nil, _), do: nil

  def matches_text(element, expected) do
    assert get_text(element) =~ expected

    element
  end

  defp decoded_response(conn, status_code) do
    conn
    |> Phoenix.ConnTest.html_response(status_code)
    |> HtmlEntities.decode
  end

  defp get_attribute(element, attribute) when is_atom(attribute), do: get_attribute(element, Atom.to_string(attribute))
  defp get_attribute(element, attribute), do: hd(Floki.attribute(element, attribute))
  defp get_text(element), do: Floki.text(element)
  defp get_href(element), do: get_attribute(element, :href)
end
