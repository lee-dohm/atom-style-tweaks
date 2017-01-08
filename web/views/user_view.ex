defmodule AtomStyleTweaks.UserView do
  use AtomStyleTweaks.Web, :view

  def resize_avatar(user, size) do
    "#{user.avatar_url}&s=#{size}"
  end
end
