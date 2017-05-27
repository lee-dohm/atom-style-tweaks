defmodule AtomStyleTweaks.TweakController.Test do
  use AtomStyleTweaks.ConnCase

  import Phoenix.Controller

  def create_tweak(name, tweak_params) do
    conn = build_conn()

    post(conn, tweak_path(conn, :create, name), %{"name" => name, "tweak" => tweak_params})
  end

  def edit_tweak, do: edit_tweak(insert(:tweak))

  def edit_tweak(tweak) do
    conn = build_conn()

    get(conn, tweak_path(conn, :edit, tweak.user.name, tweak.id))
  end

  def new_tweak do
    conn = build_conn()

    get(conn, tweak_path(conn, :new, insert(:user)))
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

  test "create valid tweak succeeds" do
    user = insert(:user)
    tweak = params_for(:tweak)
    conn = create_tweak(user.name, tweak)

    assert redirected_to(conn) =~ "/#{user.name}/"
  end

  test "create tweak with invalid tweak parameters renders the new template" do
    user = insert(:user)
    tweak = params_for(:tweak, title: "")
    conn = create_tweak(user.name, tweak)

    assert view_template(conn) == "new.html"
  end

  test "new tweak shows appropriate controls" do
    conn = new_tweak()

    assert find_single_element(conn, "input#tweak_title")
           |> has_attribute(:placeholder, "Title")
    assert find_single_element(conn, "select#tweak_type")
    assert find_single_element(conn, "textarea#tweak_code")
           |> has_attribute(:placeholder, "Enter tweak code")
    assert find_single_element(conn, "button.btn.btn-primary")
           |> has_text("Save new tweak")
           |> has_attribute(:type, "submit")
  end

  test "edit tweak shows cancel button" do
    tweak = insert(:tweak)
    conn = edit_tweak(tweak)

    assert find_single_element(conn, "a.btn.btn-danger")
           |> has_text("Cancel")
           |> links_to(tweak_path(conn, :show, tweak.user.name, tweak.id))
  end

  test "show tweak displays the tweak's title" do
    tweak = insert(:tweak)
    conn = show_tweak(tweak)

    assert find_single_element(conn, "main h3")
           |> has_text(tweak.title)
  end

  test "show tweak displays the tweak's code" do
    tweak = insert(:tweak, code: "This is some cool code huh?")
    conn = show_tweak(tweak)

    assert find_single_element(conn, "code")
           |> has_text(tweak.code)
  end

  test "show tweak when not logged in does not show edit button" do
    conn = show_tweak()

    refute find_single_element(conn, "span.octicon.octicon-pencil")
  end

  test "show tweak when logged in as a different user does not show edit button" do
    conn = show_tweak(insert(:tweak), logged_in_as: build(:user))

    refute find_single_element(conn, "span.octicon.octicon-pencil")
  end

  test "show tweak when logged in as owning user shows the edit button" do
    user = insert(:user)
    tweak = insert(:tweak, user: user)
    conn = show_tweak(tweak, logged_in_as: user)

    assert find_single_element(conn, "a[href=\"#{tweak_path(conn, :edit, tweak.user.name, tweak.id)}\"]")
  end
end
