defmodule AtomStyleTweaks.HtmlAssertions do
  @moduledoc """
  Enhanced assertions for working with HTML.
  """
  import ExUnit.Assertions

  @type element_result :: Floki.html_tree | nil

  @doc """
  Finds an element matching the given CSS-style selector.
  """
  @spec find_element(Plug.Conn.t, String.t) :: element_result
  def find_element(conn, selector)

  def find_element(conn, selector) do
    element = conn
              |> decoded_response(200)
              |> Floki.find(selector)

    if element == [], do: nil, else: element
  end

  @doc """
  Asserts that the element has the named attribute.
  """
  @spec has_attribute(element_result, String.t | atom) :: element_result
  def has_attribute(element, attribute)

  def has_attribute(nil, _), do: nil

  def has_attribute(element, expected_attribute) do
    assert get_attribute(element, expected_attribute)

    element
  end

  @doc """
  Asserts that the element has the named attribute with the given value.
  """
  @spec has_attribute(element_result, String.t | atom, String.t) :: element_result
  def has_attribute(element, attribute, value)

  def has_attribute(nil, _, _), do: nil

  def has_attribute(element, attribute, expected_value) do
    assert get_attribute(element, attribute) == expected_value

    element
  end

  @doc """
  Asserts that the element's inner text is equal to the given string.
  """
  @spec has_text(element_result, String.t) :: element_result
  def has_text(element, text)

  def has_text(nil, _), do: nil

  def has_text(element, expected) do
    assert get_text(element) == expected

    element
  end

  @doc """
  Asserts that the element has an `href` attribute that equates to the given URL.
  """
  @spec links_to(element_result, String.t) :: element_result
  def links_to(element, url)

  def links_to(nil, _), do: nil

  def links_to(element, expected) do
    assert get_href(element) == expected

    element
  end

  @doc """
  Asserts that the element's inner text matches the given pattern.
  """
  @spec matches_text(element_result, Regex.t | String.t) :: element_result
  def matches_text(element, pattern)

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
