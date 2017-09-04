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
           |> log_in_as(logged_in_user)

    get(conn, user_path(conn, :show, user.name))
  end

  test "show user that does not exist gives 404" do
    conn = show_user(build(:user))

    assert response(conn, 404)
  end

  test "show user when not logged in displays user name" do
    user = insert(:user)
    conn = show_user(user)

    assert conn
           |> find_single_element("#user-info-block h2")
           |> has_text(user.name)
  end

  test "show user when not logged in displays user avatar" do
    user = insert(:user)
    conn = show_user(user)

    assert conn
           |> find_single_element("#user-info-block img.avatar")
           |> get_attribute(:src) =~ user.avatar_url
  end

  test "show non-staff user when not logged in does not show staff badge" do
    conn = show_user(insert(:user))

    refute find_all_elements(conn, "#staff-badge")
  end

  test "show staff user when not logged in displays staff badge" do
    user = insert(:user, site_admin: true)
    conn = show_user(user)

    assert conn
           |> find_single_element("#user-info-block span#staff-badge")
           |> has_text("Staff")
  end

  test "show user when logged in as different user displays not logged in user's name" do
    user = insert(:user)
    conn = show_user(user, logged_in_as: insert(:user))

    assert conn
           |> find_single_element("#user-info-block h2")
           |> has_text(user.name)
  end

  test "show user when logged in as different user does not show 'New tweak' button" do
    user = insert(:user)
    conn = show_user(user, logged_in_as: insert(:user))

    refute find_all_elements(conn, "#new-tweak-button")
  end

  test "show user without tweaks when not logged in says doesn't have any tweaks yet" do
    conn = show_user()

    assert conn
           |> find_single_element(".blankslate h3")
           |> matches_text("doesn't have any tweaks yet")
  end

  test "show user with tweaks when not logged in displays the tweaks" do
    user = insert(:user)
    tweaks = insert_list(3, :tweak, user: user)
    conn = show_user(user)

    elements = find_all_elements(conn, "a.title")

    Enum.each(tweaks, fn(tweak) ->
      assert elements
             |> has_text(tweak.title)
             |> links_to(user_tweak_path(conn, :show, tweak.user.name, tweak.id))
    end)
  end

  test "show user when logged in as that user shows 'New tweak' button" do
    user = insert(:user)
    conn = show_user(user, logged_in_as: user)

    assert conn
           |> find_single_element("#new-tweak-button")
           |> has_text("New tweak")
  end

  test "show user with no tweaks when logged in as that user shows blankslate message" do
    user = insert(:user)
    conn = show_user(user, logged_in_as: user)

    assert conn
           |> find_single_element(".blankslate h3")
           |> has_text("This is where your tweaks will be listed")
  end

  test "show user with tweaks when logged in as that user lists tweaks" do
    user = insert(:user)
    tweaks = insert_list(3, :tweak, user: user)
    conn = show_user(user, logged_in_as: user)

    elements = find_all_elements(conn, "a.title")

    Enum.each(tweaks, fn(tweak) ->
      assert elements
             |> has_text(tweak.title)
             |> links_to(user_tweak_path(conn, :show, tweak.user.name, tweak.id))
    end)
  end
end
