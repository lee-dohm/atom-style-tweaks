defmodule Support.Setup do
  @moduledoc """
  Functions that are designed to be used as chained `setup` callbacks.

  Each callback takes certain values from the `context` state and merges in new or updated values.
  Because they only get supplied the `context` as a parameter, each function has a contract around
  the keys that are used.

  ## Categories

  * `insert` functions create database records
  * `request` functions navigate to web pages

  ## Examples

  Inserts a user, creates a tweak for that user, and then stars that tweak for that user:

  ```
  setup [:insert_user, :insert_tweak, :insert_star]
  ```
  """
  import Phoenix.ConnTest

  import AtomTweaks.Factory

  alias AtomTweaks.Accounts
  alias AtomTweaks.Tweaks
  alias AtomTweaksWeb.Router.Helpers, as: Routes
  alias Plug.Test, as: PlugTest

  @endpoint AtomTweaksWeb.Endpoint

  @doc """
  Inserts a release note.

  ## Outputs

  * `:note` -- Release note that was inserted into the database
  """
  def insert_release_note(context)

  def insert_release_note(_context) do
    note = insert(:note)

    {:ok, note: note}
  end

  @doc """
  Inserts a site admin user into the database.

  ## Outputs

  * `:user` - Site admin user record
  """
  def insert_site_admin(context)

  def insert_site_admin(_context) do
    user = insert(:user, site_admin: true)

    {:ok, user: user}
  end

  @doc """
  Stars a tweak by a user.

  ## Inputs

  * `:user` - User to star the tweak
  * `:tweak` - Tweak to be starred

  ## Outputs

  * `:star` - Star record
  """
  def insert_star(context)

  def insert_star(%{user: user, tweak: tweak}) do
    {:ok, star} = Accounts.star_tweak(user, tweak)

    {:ok, star: star}
  end

  @doc """
  Inserts a single tweak for a user.

  ## Inputs

  Inserts a tweak for the first of:

  1. `:current_user`
  1. `:user`
  1. Inserts a new user

  ## Outputs

  * `:tweak` - New tweak record
  * `:user` - User record that created the tweak
  """
  def insert_tweak(context)

  def insert_tweak(%{current_user: user}) do
    tweak = insert(:tweak, user: user)

    {:ok, tweak: tweak}
  end

  def insert_tweak(%{user: user}) do
    tweak = insert(:tweak, user: user)

    {:ok, tweak: tweak}
  end

  def insert_tweak(_context) do
    user = insert(:user)
    tweak = insert(:tweak, user: user)

    {:ok, tweak: tweak, user: user}
  end

  def insert_tokens(context)

  def insert_tokens(%{user: user}) do
    tokens = insert_list(3, :token, user: user)

    {:ok, tokens: tokens}
  end

  @doc """
  Inserts a user into the database.

  ## Outputs

  * `:user` - New user record
  """
  def insert_user(context)

  def insert_user(_context) do
    user = insert(:user)

    {:ok, user: user}
  end

  @doc """
  Inserts a user with three tweaks into the database.

  ## Outputs

  * `:user` - New user record
  * `:tweaks` - New tweak records
  """
  def insert_user_with_tweaks(context)

  def insert_user_with_tweaks(_context) do
    user = insert(:user)
    tweaks = insert_list(3, :tweak, user: user)

    {:ok, user: user, tweaks: tweaks}
  end

  @doc """
  Forks a tweak.

  ## Inputs

  * `:tweaks`

  ## Outputs

  * `:fork_user` -- User that forked the tweak
  * `:fork_tweak` -- New fork tweak
  * `:forked_tweak` -- Tweak that was forked
  """
  def fork_tweak(%{tweaks: tweaks}) do
    fork_user = insert(:user)
    forked_tweak = hd(tweaks)
    {:ok, fork_tweak} = Tweaks.fork_tweak(forked_tweak, fork_user)

    {:ok, fork_user: fork_user, fork_tweak: fork_tweak, forked_tweak: forked_tweak}
  end

  @doc """
  Inserts an init tweak.

  ## Outputs

  * `:init_tweak` -- Tweak that was created
  """
  def insert_init_tweak(context)

  def insert_init_tweak(_context) do
    tweak = insert(:tweak, type: "init")

    {:ok, init_tweak: tweak}
  end

  @doc """
  Inserts a style tweak.

  ## Outputs

  * `:style_tweak` -- Tweak that was created
  """
  def insert_style_tweak(context)

  def insert_style_tweak(_context) do
    tweak = insert(:tweak, type: "style")

    {:ok, style_tweak: tweak}
  end

  @doc """
  Creates an invalid set of parameters for a tweak.

  ## Outputs

  * `:tweak_params` -- Invalid params
  """
  def invalid_tweak_params(_context) do
    {:ok, tweak_params: params_for(:tweak, title: "")}
  end

  @doc """
  Logs in as a user.

  ## Inputs

  * `:conn` -- Connection object

  Logs in as (in priority order):

  1. `:user`
  1. Inserts a new user into the database

  ## Outputs

  * `:current_user` - User record used to log in
  """
  def log_in(context)

  def log_in(%{conn: conn, user: user}) do
    conn = PlugTest.init_test_session(conn, %{current_user: user})

    {:ok, conn: conn, current_user: user}
  end

  def log_in(%{conn: conn}) do
    user = insert(:user)
    conn = PlugTest.init_test_session(conn, %{current_user: user})

    {:ok, conn: conn, current_user: user}
  end

  @doc """
  Requests the admin release note edit page.

  ## Inputs

  * `:conn` -- Connection object
  * `:note` -- Release note to edit

  ## Outputs

  * `:conn` -- Updated connection object
  """
  def request_admin_release_note_edit(context)

  def request_admin_release_note_edit(%{conn: conn, note: note}) do
    conn = get(conn, Routes.admin_release_note_path(conn, :edit, note))

    {:ok, conn: conn}
  end

  @doc """
  Requests the admin release notes index page.

  ## Inputs

  * `:conn` -- Connection object

  ## Outputs

  * `:conn` -- Updated connection object
  """
  def request_admin_release_note_index(context)

  def request_admin_release_note_index(%{conn: conn}) do
    conn = get(conn, Routes.admin_release_note_path(conn, :index))

    {:ok, conn: conn}
  end

  @doc """
  Requests the admin release note new page.

  ## Inputs

  * `:conn` -- Connection object

  ## Outputs

  * `:conn` -- Updated connection object
  """
  def request_admin_release_note_new(context)

  def request_admin_release_note_new(%{conn: conn}) do
    conn = get(conn, Routes.admin_release_note_path(conn, :new))

    {:ok, conn: conn}
  end

  @doc """
  Requests the admin release note show page.

  ## Inputs

  * `:conn` -- Connection object
  * `:note` -- Release note to show

  ## Outputs

  * `:conn` -- Updated connection object
  """
  def request_admin_release_note_show(context)

  def request_admin_release_note_show(%{conn: conn, note: note}) do
    conn = get(conn, Routes.admin_release_note_path(conn, :show, note))

    {:ok, conn: conn}
  end

  @doc """
  Creates a new user in the database to request a page.

  ## Outputs

  * `:request_user` - User record that requests a page
  """
  def request_user(_context) do
    {:ok, request_user: insert(:user)}
  end

  @doc """
  Requests the create tweak page.

  ## Inputs

  * `:conn` -- Connection object
  * `:current_user` - Currently logged in user record, if any
  * `:request_user` - User record requesting the page
  * `:tweak_params` - Parameters to use to create the tweak

  ## Outputs

  * `:conn` - Updated connection object
  """
  def request_create_tweak(context)

  def request_create_tweak(%{
        conn: conn,
        current_user: _,
        request_user: user,
        tweak_params: tweak_params
      }) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, Routes.tweak_path(conn, :create), params)

    {:ok, conn: conn}
  end

  def request_create_tweak(%{conn: conn, current_user: user, tweak_params: tweak_params}) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, Routes.tweak_path(conn, :create), params)

    {:ok, conn: conn}
  end

  def request_create_tweak(%{conn: conn, tweak_params: tweak_params, user: user}) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, Routes.tweak_path(conn, :create), params)

    {:ok, conn: conn}
  end

  @doc """
  Requests the edit tweak page.

  ## Inputs

  * `:conn` - `Plug.Conn` object
  * `:tweak` - Tweak record to edit

  ## Outputs

  * `:conn` - `Plug.Conn` object after the page is rendered
  """
  def request_edit_tweak(context)

  def request_edit_tweak(%{conn: conn, tweak: tweak}) do
    conn = get(conn, Routes.tweak_path(conn, :edit, tweak))

    {:ok, conn: conn}
  end

  @doc """
  Requests the new tweak page.

  ## Inputs

  * `:conn` - `Plug.Conn` object

  ## Outputs

  * `:conn` - `Plug.Conn` object after the page is rendered
  """
  def request_new_tweak(context)

  def request_new_tweak(%{conn: conn}) do
    conn = get(conn, Routes.tweak_path(conn, :new))

    {:ok, conn: conn}
  end

  @doc """
  Requests the show tweak page.

  ## Inputs

  * `:conn` - `Plug.Conn` object
  * `:tweak` - Tweak record to show

  ## Outputs

  * `:conn` - `Plug.Conn` object after the page is rendered
  """
  def request_show_tweak(context)

  def request_show_tweak(%{conn: conn, tweak: tweak}) do
    conn = get(conn, Routes.tweak_path(conn, :show, tweak))

    {:ok, conn: conn}
  end

  @doc """
  Requests the show user page.

  ## Inputs

  * `:conn` - `Plug.Conn` object
  * `:current_user` - Currently logged in user record
  * `:request_user` - User record to show
  * `:user` - User record to show

  ## Outputs

  * `:conn` - `Plug.Conn` object after the page is rendered
  * `:path` - Path that was navigated to
  """
  def request_show_user(context)

  def request_show_user(%{conn: conn, current_user: _, request_user: user}) do
    path = Routes.user_path(conn, :show, user.name)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  def request_show_user(%{conn: conn, user: user}) do
    path = Routes.user_path(conn, :show, user.name)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  @doc """
  Navigates to the stars page for a user.

  ## Inputs

  * `:conn` - `Plug.Conn` object
  * `:user` - User whose stars we will view

  ## Outputs

  * `:conn` - Updated `Plug.Conn` object
  * `:path` - Path that was navigated to
  """
  def request_stars(context)

  def request_stars(%{conn: conn, user: user}) do
    path = Routes.user_star_path(conn, :index, user)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  def request_forks(context)

  def request_forks(%{conn: conn, forked_tweak: forked_tweak}) do
    path = Routes.tweak_fork_path(conn, :index, forked_tweak)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  def request_forks(%{conn: conn, tweak: tweak}) do
    path = Routes.tweak_fork_path(conn, :index, tweak)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  @doc """
  Requests the about page.
  """
  def request_page_about(context)

  def request_page_about(%{conn: conn}) do
    conn = get(conn, Routes.page_path(conn, :about))

    {:ok, conn: conn}
  end

  @doc """
  Requests the home page.
  """
  def request_page_index(context)

  def request_page_index(%{conn: conn}) do
    conn = get(conn, Routes.page_path(conn, :index))

    {:ok, conn: conn}
  end

  @doc """
  Requests the release notes page.
  """
  def request_page_release_notes(context)

  def request_page_release_notes(%{conn: conn}) do
    conn = get(conn, Routes.page_path(conn, :release_notes))

    {:ok, conn: conn}
  end

  def request_user_token_index(context)

  def request_user_token_index(%{conn: conn, user: user}) do
    conn = get(conn, Routes.user_token_path(conn, :index, user))

    {:ok, conn: conn}
  end

  def valid_tweak_params(_context) do
    {:ok, tweak_params: params_for(:tweak)}
  end
end
