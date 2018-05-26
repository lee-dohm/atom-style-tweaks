defmodule AtomStyleTweaksWeb.PageMetadataTest do
  use AtomStyleTweaksWeb.ConnCase
  use Phoenix.HTML

  alias AtomStyleTweaksWeb.PageMetadata

  alias Phoenix.HTML

  def add_metadata(conn, metadata) do
    conn = PageMetadata.add(conn, metadata)

    conn.assigns[:page_metadata]
  end

  def render_metadata(conn, metadata) do
    conn
    |> PageMetadata.add(metadata)
    |> PageMetadata.render()
    |> render_fixup()
  end

  defp render_fixup(nil), do: nil
  defp render_fixup(list) when is_list(list), do: Enum.reduce(list, "", fn(safe, acc) -> "#{acc} #{HTML.safe_to_string(safe)}" end)
  defp render_fixup(safe), do: HTML.safe_to_string(safe)

  describe "add" do
    setup context do
      conn = get(context.conn, "/")

      {:ok, conn: conn}
    end

    test "has no metadata when nil metadata is added", context do
      metadata = add_metadata(context.conn, nil)

      assert metadata == nil
    end

    test "has some default values when empty metadata is added", context do
      metadata = add_metadata(context.conn, [])

      assert length(metadata) == 2
      assert Enum.member?(metadata, [property: "og:url", content: "http://www.example.com/"])
      assert Enum.member?(metadata, [property: "og:site_name", content: "Atom Tweaks"])
    end

    test "has all expected values when something is added", context do
      metadata = add_metadata(context.conn, [property: "og:title", content: "Test title"])

      assert length(metadata) == 3
      assert Enum.member?(metadata, [property: "og:url", content: "http://www.example.com/"])
      assert Enum.member?(metadata, [property: "og:site_name", content: "Atom Tweaks"])
      assert Enum.member?(metadata, [property: "og:title", content: "Test title"])
    end

    test "has all the expected values when a list is added", context do
      metadata = add_metadata(context.conn, [[property: "og:title", content: "Test title"], [foo: "bar", bar: "baz"]])

      assert length(metadata) == 4
      assert Enum.member?(metadata, [property: "og:url", content: "http://www.example.com/"])
      assert Enum.member?(metadata, [property: "og:site_name", content: "Atom Tweaks"])
      assert Enum.member?(metadata, [property: "og:title", content: "Test title"])
      assert Enum.member?(metadata, [foo: "bar", bar: "baz"])
    end
  end

  describe "render" do
    test "returns nil when there is no page metadata", context do
      result = render_metadata(context.conn, nil)

      assert result == nil
    end

    test "returns the expected HTML when page metadata has been set", context do
      result = render_metadata(context.conn, [])

      assert result =~ "<meta content=\"http://www.example.com/\" property=\"og:url\">"
      assert result =~ "<meta content=\"Atom Tweaks\" property=\"og:site_name\">"
    end
  end
end
