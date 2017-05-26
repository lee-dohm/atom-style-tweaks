defmodule AtomStyleTweaks.TweakController.Test do
  use AtomStyleTweaks.ConnCase

  def edit_tweak, do: edit_tweak(insert(:tweak))

  def edit_tweak(tweak) do
    conn = build_conn()

    get(conn, tweak_path(conn, :edit, tweak.user.name, tweak.id))
  end

  def show_tweak, do: show_tweak(insert(:tweak))

  def show_tweak(tweak) do
    conn = build_conn()

    get(conn, tweak_path(conn, :show, tweak.user.name, tweak.id))
  end

  def show_tweak(tweak, logged_in_as: logged_in_user) do
    conn = build_conn()
    conn = log_in_as(conn, logged_in_user)

    get(conn, tweak_path(conn, :show, tweak.user.name, tweak.id))
  end

  test "edit tweak shows cancel button" do
    tweak = insert(:tweak)
    conn = edit_tweak(tweak)

    assert find_element(conn, "a.btn.btn-danger")
           |> has_text("Cancel")
           |> links_to(tweak_path(conn, :show, tweak.user.name, tweak.id))
  end

  test "show tweak displays the tweak's title" do
    tweak = insert(:tweak)
    conn = show_tweak(tweak)

    assert decoded_response(conn, 200) =~ tweak.title
  end

  test "show tweak displays the tweak's code" do
    tweak = insert(:tweak, code: "This is some cool code huh?")
    conn = show_tweak(tweak)

    assert decoded_response(conn, 200) =~ "This is some cool code huh?"
  end

  test "show tweak when not logged in does not show edit button" do
    conn = show_tweak()

    refute decoded_response(conn, 200) =~ "octicon-pencil"
  end

  test "show tweak when logged in as a different user does not show edit button" do
    user = build(:user)
    conn = show_tweak(insert(:tweak), logged_in_as: user)

    refute decoded_response(conn, 200) =~ "octicon-pencil"
  end

  test "show tweak when logged in as owning user shows the edit button" do
    user = insert(:user)
    tweak = insert(:tweak, user: user)
    conn = show_tweak(tweak, logged_in_as: user)

    assert decoded_response(conn, 200) =~ "octicon-pencil"
  end
end
