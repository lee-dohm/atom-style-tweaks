defmodule AtomStyleTweaks.HtmlAssertions do
  @moduledoc """
  Fluid-interface assertions for working with HTML.

  * All of the helpers are designed to assert that any one of the top-level elements they are given
  matches the expectation.
  * All responses are treated as HTML and HTML-decoded to normalize the results.
  * All responses are expected to have a `200` status code.
  """
  import ExUnit.Assertions

  @type element_result :: Floki.html_tree | nil
  @type selector :: String.t
  @type single_element :: [{String.t, list, list}]

  @doc """
  Finds all elements matching the given CSS-style selector.

  Returns `nil` when no matching elements are found.
  """
  @spec find_all_elements(Plug.Conn.t, selector) :: element_result
  def find_all_elements(conn, selector) do
    element = conn
              |> decode_response
              |> Floki.find(selector)

    if element == [], do: nil, else: element
  end

  @doc """
  Finds a single element matching the given CSS-style selector.

  If more than one element is found matching the selector, the assertion fails.

  Returns `nil` when no matching elements are found.
  """
  @spec find_single_element(Plug.Conn.t, selector) :: element_result
  def find_single_element(conn, selector) do
    element = conn
              |> decode_response
              |> Floki.find(selector)

    if length(element) > 1, do: flunk("More than one element was found matching \"#{selector}\"")

    if element == [], do: nil, else: element
  end

  @spec get_attribute(single_element, String.t | atom) :: String.t
  def get_attribute(list, _) when length(list) > 1, do: flunk("Cannot get an attribute from more than one element")
  def get_attribute(element, attribute) when is_atom(attribute), do: get_attribute(element, Atom.to_string(attribute))
  def get_attribute(element, attribute), do: hd(Floki.attribute(element, attribute))

  @spec get_text(single_element) :: String.t
  def get_text(list) when length(list) > 1, do: flunk("Cannot get the text from more than one element")
  def get_text(element), do: Floki.text(element)

  @doc """
  Asserts that any of the elements has the named attribute.
  """
  @spec has_attribute(element_result, String.t | atom) :: element_result
  def has_attribute(elements, attribute)

  def has_attribute(nil, _), do: nil

  def has_attribute(elements, expected) when length(elements) > 1 do
    assert Enum.any?(elements, &(get_attribute([&1], expected))),
           "None of the elements had the expected attribute \"#{expected}\""

    elements
  end

  def has_attribute(element, expected) do
    assert get_attribute(element, expected)

    element
  end

  @doc """
  Asserts that any of the elements has the named attribute with the given value.
  """
  @spec has_attribute(element_result, String.t | atom, String.t) :: element_result
  def has_attribute(elements, attribute, value)

  def has_attribute(nil, _, _), do: nil

  def has_attribute(elements, attribute, value) when length(elements) > 1 do
    assert Enum.any?(elements, &(get_attribute([&1], attribute) == value)),
           "None of the elements had an attribute \"#{attribute}\" equal to \"#{value}\""

    elements
  end

  def has_attribute(element, attribute, expected_value) do
    assert get_attribute(element, attribute) == expected_value

    element
  end

  @doc """
  Asserts that any of the elements' inner text is equal to the given string.
  """
  @spec has_text(element_result, String.t) :: element_result
  def has_text(elements, text)

  def has_text(nil, _), do: nil

  def has_text(elements, expected) when length(elements) > 1 do
    assert Enum.any?(elements, &(get_text([&1]) == expected)),
           "None of the elements had the text \"#{expected}\""

    elements
  end

  def has_text(element, expected) do
    assert get_text(element) == expected

    element
  end

  @doc """
  Asserts that any of the elements has an `href` attribute that equates to the given URL.
  """
  @spec links_to(element_result, String.t) :: element_result
  def links_to(elements, url)

  def links_to(nil, _), do: nil

  def links_to(elements, expected) when length(elements) > 1 do
    assert Enum.any?(elements, &(get_href([&1]) == expected)),
           "None of the elements linked to \"#{expected}\""

    elements
  end

  def links_to(element, expected) do
    assert get_href(element) == expected

    element
  end

  @doc """
  Asserts that any of the elements' inner text matches the given pattern.
  """
  @spec matches_text(element_result, Regex.t | String.t) :: element_result
  def matches_text(elements, pattern)

  def matches_text(nil, _), do: nil

  def matches_text(elements, expected) when length(elements) > 1 do
    assert Enum.any?(elements, &(get_text([&1]) =~ expected)),
           "None of the elements' inner text matched \"#{expected}\""

    elements
  end

  def matches_text(element, expected) do
    assert get_text(element) =~ expected

    element
  end

  defp decode_response(conn, status_code \\ 200) do
    conn
    |> Phoenix.ConnTest.html_response(status_code)
    |> HtmlEntities.decode
  end

  defp get_href(element), do: get_attribute(element, :href)
end
