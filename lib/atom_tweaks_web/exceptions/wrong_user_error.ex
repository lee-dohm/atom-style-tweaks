defmodule AtomTweaksWeb.WrongUserError do
  @moduledoc """
  Exception raised when someone attempts to modify a resource they don't own.
  """
  alias AtomTweaksWeb.WrongUserError

  defexception plug_status: 404,
               message: "not found",
               conn: nil,
               current_user: nil,
               resource_owner: nil

  def exception(opts) do
    conn = Keyword.fetch!(opts, :conn)
    current_user = Keyword.fetch!(opts, :current_user)
    resource_owner = Keyword.fetch!(opts, :resource_owner)

    %WrongUserError{
      message: "#{current_user.name} is not the resource owner #{resource_owner.name}",
      conn: conn,
      current_user: current_user,
      resource_owner: resource_owner
    }
  end
end
