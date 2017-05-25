defmodule AtomStyleTweaks.PageController.Test do
  use AtomStyleTweaks.ConnCase
  use Plug.Test

  require Logger
  import AtomStyleTweaks.Factory

  def get_page(path_fn, options)

  def get_page(path_fn, nil) do
    conn = build_conn()

    get(conn, path_fn.(conn))
  end

  def get_page(path_fn, :logged_in) do
    conn = build_conn()
    user = build(:user)
    conn = init_test_session(conn, %{current_user: user})

    get(conn, path_fn.(conn))
  end

  def index(options \\ nil)
  def index(options), do: get_page(&(page_path(&1, :index)), options)

  def about(options \\ nil)
  def about(options), do: get_page(&(page_path(&1, :about)), options)

  test "index shows home page link" do
    conn = index()

    assert html_response(conn, 200) =~ "Atom Tweaks"
    assert html_response(conn, 200) =~ "href=\"#{page_path(conn, :index)}\""
  end

  test "index does not show 'New tweak' button when not logged in" do
    conn = index()

    refute html_response(conn, 200) =~ "New tweak"
  end

  test "index shows new tweak button when logged in" do
    conn = index(:logged_in)

    assert html_response(conn, 200) =~ "New tweak"
  end

  test "index shows a list of tweaks" do
    styles = insert_list(3, :style)
    conn = index()

    Enum.each(styles, fn(style) ->
      assert html_response(conn, 200) =~ style.title
      assert html_response(conn, 200) =~ style.user.name
    end)
  end

  test "index shows styles tab" do
    conn = index()

    assert html_response(conn, 200) =~ "Styles"
  end

  test "index shows About link" do
    conn = index()

    assert html_response(conn, 200) =~ "About"
    assert html_response(conn, 200) =~ page_path(conn, :about)
  end

  test "index shows the GitHub link" do
    conn = index()

    assert html_response(conn, 200) =~ "https://github.com/lee-dohm/atom-style-tweaks"
  end

  test "about page shows some about text" do
    conn = about()

    assert html_response(conn, 200) =~ "About Atom Tweaks"
  end
end
