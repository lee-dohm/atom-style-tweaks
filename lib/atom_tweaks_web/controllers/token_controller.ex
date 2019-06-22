defmodule AtomTweaksWeb.TokenController do
  @moduledoc """
  Handles all requests for user token routes.
  """

  use AtomTweaksWeb, :controller

  alias AtomTweaks.Accounts
  alias AtomTweaks.Accounts.Token
  alias AtomTweaksWeb.ForbiddenUserError

  require Logger

  plug(:ensure_authenticated_user)
  plug(:ensure_site_admin)

  @doc """
  Creates a new token.
  """
  @spec create(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def create(conn, %{"token" => token_params, "user_id" => name}) do
    user = Accounts.get_user!(name)

    params =
      token_params
      |> Map.put("scopes", ["release_notes/write"])
      |> Map.put("user_id", user.id)

    changeset = Token.changeset(%Token{}, params)

    case Repo.insert(changeset) do
      {:ok, _token} ->
        redirect(conn, to: Routes.user_token_path(conn, :index, user))

      {:error, changeset} ->
        star_count = Accounts.count_stars(user)
        tweak_count = Accounts.count_tweaks(user)

        render(conn, "new.html",
          changeset: changeset,
          star_count: star_count,
          tweak_count: tweak_count,
          user: user
        )
    end
  end

  @doc """
  Displays the list of tokens for a user.
  """
  @spec index(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def index(conn, %{"user_id" => name}) do
    user = Accounts.get_user!(name)

    unless conn.assigns[:current_user].id == user.id do
      raise(ForbiddenUserError, conn: conn)
    end

    tokens = Accounts.list_tokens(user)
    star_count = Accounts.count_stars(user)
    tweak_count = Accounts.count_tweaks(user)

    render(conn, "index.html",
      user: user,
      tokens: tokens,
      star_count: star_count,
      tweak_count: tweak_count
    )
  end

  @doc """
  Displays the new token form.
  """
  @spec new(Plug.Conn.t(), Map.t()) :: Plug.Conn.t()
  def new(conn, %{"user_id" => name}) do
    user = Accounts.get_user!(name)

    unless conn.assigns[:current_user].id == user.id do
      raise(ForbiddenUserError, conn: conn)
    end

    changeset = Accounts.change_token(%Token{user: user})
    star_count = Accounts.count_stars(user)
    tweak_count = Accounts.count_tweaks(user)

    render(conn, "new.html",
      changeset: changeset,
      star_count: star_count,
      tweak_count: tweak_count,
      user: user
    )
  end
end
