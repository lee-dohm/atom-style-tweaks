defmodule Support.SetupHelpers do
  @moduledoc """
  Functions that are designed to be used as chained `setup` callbacks.

  Each callback takes certain values from the `context` state and merges in new or updated values
  upon return.
  """
  import Phoenix.ConnTest

  import AtomTweaks.Factory
  import AtomTweaksWeb.Router.Helpers

  alias AtomTweaks.Accounts

  @endpoint AtomTweaksWeb.Endpoint

  def insert_star(%{user: user, tweak: tweak}) do
    {:ok, star} = Accounts.star_tweak(user, tweak)

    {:ok, star: star}
  end

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

  def invalid_request_user(_context) do
    {:ok, request_user: build(:user)}
  end

  def request_user(_context) do
    {:ok, request_user: insert(:user)}
  end

  def insert_user(_context) do
    user = insert(:user)

    {:ok, user: user}
  end

  def insert_user_with_tweaks(_context) do
    user = insert(:user)
    tweaks = insert_list(3, :tweak, user: user)

    {:ok, user: user, tweaks: tweaks}
  end

  def insert_site_admin(_context) do
    user = insert(:user, site_admin: true)

    {:ok, user: user}
  end

  def log_in(%{conn: conn, user: user}) do
    conn = Plug.Test.init_test_session(conn, %{current_user: user})

    {:ok, conn: conn, current_user: user}
  end

  def log_in(%{conn: conn}) do
    user = insert(:user)
    conn = Plug.Test.init_test_session(conn, %{current_user: user})

    {:ok, conn: conn, current_user: user}
  end

  @doc """
  Builds a create tweak request for a different user than the one logged in.
  """
  def request_create_tweak(%{
        conn: conn,
        current_user: _,
        request_user: user,
        tweak_params: tweak_params
      }) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, tweak_path(conn, :create), params)

    {:ok, conn: conn}
  end

  @doc """
  Builds a create tweak request for the logged in user.
  """
  def request_create_tweak(%{conn: conn, current_user: user, tweak_params: tweak_params}) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, tweak_path(conn, :create), params)

    {:ok, conn: conn}
  end

  @doc """
  Builds a create tweak request for the given user when nobody is logged in.
  """
  def request_create_tweak(%{conn: conn, tweak_params: tweak_params, user: user}) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, tweak_path(conn, :create), params)

    {:ok, conn: conn}
  end

  @doc """
  Builds an edit tweak request.
  """
  def request_edit_tweak(%{conn: conn, tweak: tweak}) do
    conn = get(conn, tweak_path(conn, :edit, tweak))

    {:ok, conn: conn}
  end

  @doc """
  Builds a new tweak request.
  """
  def request_new_tweak(%{conn: conn}) do
    conn = get(conn, tweak_path(conn, :new))

    {:ok, conn: conn}
  end

  @doc """
  Builds a show tweak request.
  """
  def request_show_tweak(%{conn: conn, tweak: tweak}) do
    conn = get(conn, tweak_path(conn, :show, tweak))

    {:ok, conn: conn}
  end

  def request_show_user(%{conn: conn, current_user: _, request_user: user}) do
    path = user_path(conn, :show, user.name)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  def request_show_user(%{conn: conn, user: user}) do
    path = user_path(conn, :show, user.name)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  @doc """
  Navigates to the stars page for `user`.

  ## Context modifications

  * **Update:** `conn` context variable with the current state after the navigation
  * **Add:** `path` context variable with the path navigated to
  """
  def request_stars(%{conn: conn, user: user}) do
    path = user_star_path(conn, :index, user)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  def valid_tweak_params(_context) do
    {:ok, tweak_params: params_for(:tweak)}
  end

  def invalid_tweak_params(_context) do
    {:ok, tweak_params: params_for(:tweak, title: "")}
  end
end
