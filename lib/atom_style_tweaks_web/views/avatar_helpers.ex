defmodule AtomStyleTweaksWeb.AvatarHelpers do
  @moduledoc """
  Helper functions for displaying [avatars](http://primercss.io/avatars/).
  """

  use Phoenix.HTML

  alias AtomStyleTweaksWeb.User

  @doc """
  Displays the avatar for the `user`.

  ## Options

  Valid options are:

  * `size` the value in pixels to use for both the width and height of the avatar image
  """
  @spec avatar(User.t, keyword) :: Phoenix.HTML.safe
  def avatar(user, options \\ [])

  def avatar(user, []) do
    content_tag(:img, "", class: "avatar", src: user.avatar_url)
  end

  def avatar(user, size: size) do
    content_tag(:img, "", class: "avatar", src: "#{user.avatar_url}&s=#{size}", width: size, height: size)
  end
end
