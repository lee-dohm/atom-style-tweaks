defmodule AtomStyleTweaks.UserController.Test do
  use AtomStyleTweaks.ConnCase

  def show_user do
    user = insert(:user)
    show_user(user)
  end

  def show_user(user) do
    conn = build_conn()
    get(conn, user_path(conn, :show, user.name))
  end

  def show_user(user, logged_in_as: logged_in_user) do
    conn = build_conn()
    conn = log_in_as(conn, logged_in_user)

    get(conn, user_path(conn, :show, user.name))
  end

  test "show user that does not exist gives 404" do
    conn = show_user(build(:user))

    assert html_response(conn, 404)
  end

  test "show user when not logged in displays user name" do
    user = insert(:user)
    conn = show_user(user)

    assert decoded_response(conn, 200) =~ user.name
  end

  test "show user when logged in as different user displays not logged in user's name" do
    user = insert(:user)
    conn = show_user(user, logged_in_as: insert(:user))

    assert decoded_response(conn, 200) =~ user.name
  end

  test "show user when logged in as different user does not show 'New tweak' button" do
    user = insert(:user)
    conn = show_user(user, logged_in_as: insert(:user))

    refute decoded_response(conn, 200) =~ "New tweak"
  end

  test "show user who is site admin shows staff badge" do
    user = insert(:user, site_admin: true)
    conn = show_user(user)

    assert decoded_response(conn, 200) =~ "Staff"
  end

  test "show user without tweaks when not logged in says doesn't have any tweaks yet" do
    conn = show_user()

    assert decoded_response(conn, 200) =~ "doesn't have any tweaks yet"
  end

  test "show user with tweaks when not logged in displays the tweaks" do
    user = insert(:user)
    tweaks = insert_list(3, :tweak, user: user)
    conn = show_user(user)

    Enum.each(tweaks, fn(tweak) ->
      assert decoded_response(conn, 200) =~ tweak.title
    end)
  end

  test "show user when logged in as that user shows 'New tweak' button" do
    user = insert(:user)
    conn = show_user(user, logged_in_as: user)

    assert decoded_response(conn, 200) =~ "New tweak"
  end

  test "show user with no tweaks when logged in as that user shows blankslate message" do
    user = insert(:user)
    conn = show_user(user, logged_in_as: user)

    assert decoded_response(conn, 200) =~ "This is where your tweaks will be listed"
  end

  test "show user with tweaks when logged in as that user lists tweaks" do
    user = insert(:user)
    tweaks = insert_list(3, :tweak, user: user)
    conn = show_user(user, logged_in_as: user)

    Enum.each(tweaks, fn(tweak) ->
      assert decoded_response(conn, 200) =~ tweak.title
    end)
  end
end
