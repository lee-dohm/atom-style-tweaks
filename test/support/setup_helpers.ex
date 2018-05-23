defmodule Support.SetupHelpers do
  @moduledoc """
  Functions that are designed to be used as chained `setup` callbacks.

  Each callback takes certain values from the `context` state and merges in new or updated values
  upon return.
  """
  import Phoenix.ConnTest

  import AtomStyleTweaks.Factory
  import AtomStyleTweaksWeb.Router.Helpers

  @endpoint AtomStyleTweaksWeb.Endpoint

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
  def request_create_tweak(%{conn: conn, current_user: _, request_user: user, tweak_params: tweak_params}) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, user_tweak_path(conn, :create, user.name), params)

    {:ok, conn: conn}
  end

  @doc """
  Builds a create tweak request for the logged in user.
  """
  def request_create_tweak(%{conn: conn, current_user: user, tweak_params: tweak_params}) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, user_tweak_path(conn, :create, user.name), params)

    {:ok, conn: conn}
  end

  @doc """
  Builds a create tweak request for the given user when nobody is logged in.
  """
  def request_create_tweak(%{conn: conn, tweak_params: tweak_params, user: user}) do
    params = %{"name" => user.name, "tweak" => tweak_params}

    conn = post(conn, user_tweak_path(conn, :create, user.name), params)

    {:ok, conn: conn}
  end

  def request_edit_tweak(%{conn: conn, current_user: _, request_user: user, tweak: tweak}) do
    conn = get(conn, user_tweak_path(conn, :edit, user, tweak))

    {:ok, conn: conn}
  end

  def request_edit_tweak(%{conn: conn, current_user: user, tweak: tweak}) do
    conn = get(conn, user_tweak_path(conn, :edit, user, tweak))

    {:ok, conn: conn}
  end

  def request_edit_tweak(%{conn: conn, tweak: tweak, user: user}) do
    conn = get(conn, user_tweak_path(conn, :edit, user, tweak))

    {:ok, conn: conn}
  end

  @doc """
  Builds a new tweak request for a different user than the one logged in.
  """
  def request_new_tweak(%{conn: conn, current_user: _, request_user: user}) do
    conn = get(conn, user_tweak_path(conn, :new, user))

    {:ok, conn: conn}
  end

  @doc """
  Builds a new tweak request for the logged in user.
  """
  def request_new_tweak(%{conn: conn, current_user: user}) do
    conn = get(conn, user_tweak_path(conn, :new, user))

    {:ok, conn: conn}
  end

  @doc """
  Builds a new tweak request for the given user when nobody is logged in.
  """
  def request_new_tweak(%{conn: conn, user: user}) do
    conn = get(conn, user_tweak_path(conn, :new, user))

    {:ok, conn: conn}
  end

  def request_show_tweak(%{conn: conn, current_user: _, request_user: user, tweak: tweak}) do
    path = user_tweak_path(conn, :show, user, tweak)
    conn = get(conn, path)

    {:ok, conn: conn, path: path}
  end

  def request_show_tweak(%{conn: conn, current_user: user, tweak: tweak}) do
    conn = get(conn, user_tweak_path(conn, :show, user, tweak))

    {:ok, conn: conn}
  end

  @doc """
  Builds a show tweak request for the given user when nobody is logged in.
  """
  def request_show_tweak(%{conn: conn, tweak: tweak, user: user}) do
    conn = get(conn, user_tweak_path(conn, :show, user, tweak))

    {:ok, conn: conn}
  end

  def valid_tweak_params(_context) do
    {:ok, tweak_params: params_for(:tweak)}
  end

  def invalid_tweak_params(_context) do
    {:ok, tweak_params: params_for(:tweak, title: "")}
  end
end
