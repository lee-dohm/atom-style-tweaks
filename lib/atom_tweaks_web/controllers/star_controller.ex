defmodule AtomTweaksWeb.StarController do
  @moduledoc """
  Handles requests of information about stars.
  """
  use AtomTweaksWeb, :controller

  alias AtomTweaks.Accounts
  alias AtomTweaks.Tweaks

  @doc """
  Shows the list of stars for the named user.
  """
  def index(conn, params)

  def index(conn, %{"user_id" => name}) do
    user = Accounts.get_user!(name)
    stars = Accounts.list_stars(user)
    star_count = Accounts.count_stars(user)
    tweak_count = Accounts.count_tweaks(user)

    render(
      conn,
      "index.html",
      user: user,
      stars: stars,
      star_count: star_count,
      tweak_count: tweak_count
    )
  end

  @doc """
  Toggles whether the current `user` has starred the tweak.

  After the state has been toggled, it redirects back to wherever it came from.
  """
  def toggle(conn, params)

  def toggle(conn = %{assigns: %{current_user: user}}, %{"tweak_id" => id})
      when user != nil do
    tweak = Tweaks.get!(id)
    user = Accounts.get_user!(user.name)

    if Tweaks.is_starred?(tweak, user) do
      {:ok, _} = Accounts.unstar_tweak(user, tweak)
    else
      {:ok, _} = Accounts.star_tweak(user, tweak)
    end

    redirect_back(conn)
  end
end
