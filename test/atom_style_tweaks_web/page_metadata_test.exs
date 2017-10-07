defmodule AtomStyleTweaksWeb.PageMetadata.Test do
  use ExUnit.Case, async: true
  use Plug.Test
  use Phoenix.HTML

  alias AtomStyleTweaksWeb.PageMetadata

  setup do
    site_name = Application.get_env(:atom_style_tweaks, :site_name)

    on_exit fn ->
      Application.put_env(:atom_style_tweaks, :site_name, site_name)
    end
  end

  test "sets the url and site name at minimum" do
    conn = PageMetadata.set(conn(:get, "/foo"), %{})
    metadata = conn.assigns.page_metadata

    assert metadata[:"og:url"] == "http://www.example.com/foo"
    assert metadata[:"og:site_name"] == "Atom Tweaks"
  end

  test "reads the site name from the application configuration" do
    Application.put_env(:atom_style_tweaks, :site_name, "Test Name")
    conn = PageMetadata.set(conn(:get, "/foo"), %{})
    metadata = conn.assigns.page_metadata

    assert metadata[:"og:site_name"] == "Test Name"
  end

  test "sets other metadata passed to it" do
    conn = PageMetadata.set(conn(:get, "/foo"), %{foo: "bar"})
    metadata = conn.assigns.page_metadata

    assert metadata[:foo] == "bar"
  end

  test "set can override built-in metadata" do
    conn = PageMetadata.set(conn(:get, "/foo"), %{:"og:site_name" => "Test Name"})
    metadata = conn.assigns.page_metadata

    assert metadata[:"og:site_name"] == "Test Name"
  end

  test "render returns nil when there is no page metadata" do
    assert PageMetadata.render(conn(:get, "/foo")) == nil
  end

  test "render emits tags for each item of metadata when it is included" do
    conn = PageMetadata.set(conn(:get, "/foo"), %{})

    assert PageMetadata.render(conn) == [
      tag(:meta, property: :"og:site_name", content: "Atom Tweaks"),
      tag(:meta, property: :"og:url", content: "http://www.example.com/foo")
    ]
  end
end
