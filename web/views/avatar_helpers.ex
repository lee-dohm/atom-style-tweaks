defmodule AtomStyleTweaks.AvatarHelpers do
  @moduledoc """
  Helper functions for displaying avatars.
  """

  use Phoenix.HTML

  def avatar(user) do
    content_tag(:img, "", class: "avatar", src: user.avatar_url)
  end

  def avatar(user, size: size) do
    content_tag(:img, "", class: "avatar", src: "#{user.avatar_url}&s=#{size}", width: size, height: size)
  end
end
