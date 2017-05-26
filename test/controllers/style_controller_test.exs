defmodule AtomStyleTweaks.StyleController.Test do
  use AtomStyleTweaks.ConnCase

  def show_style, do: show_style(insert(:style))

  def show_style(style) do
    conn = build_conn()

    get(conn, style_path(conn, :show, style.user.name, style.id))
  end

  def show_style(style, logged_in_as: logged_in_user) do
    conn = build_conn()
    conn = log_in_as(conn, logged_in_user)

    get(conn, style_path(conn, :show, style.user.name, style.id))
  end

  test "show style displays the style's title" do
    style = insert(:style)
    conn = show_style(style)

    assert decoded_response(conn, 200) =~ style.title
  end

  test "show style displays the style's code" do
    style = insert(:style, code: "This is some cool code huh?")
    conn = show_style(style)

    assert decoded_response(conn, 200) =~ "This is some cool code huh?"
  end

  test "show style when not logged in does not show edit button" do
    conn = show_style()

    refute decoded_response(conn, 200) =~ "octicon-pencil"
  end

  test "show style when logged in as a different user does not show edit button" do
    user = build(:user)
    conn = show_style(insert(:style), logged_in_as: user)

    refute decoded_response(conn, 200) =~ "octicon-pencil"
  end

  test "show style when logged in as owning user shows the edit button" do
    user = insert(:user)
    style = insert(:style, user: user)
    conn = show_style(style, logged_in_as: user)

    assert decoded_response(conn, 200) =~ "octicon-pencil"
  end
end
