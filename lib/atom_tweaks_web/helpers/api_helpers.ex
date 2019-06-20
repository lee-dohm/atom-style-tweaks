defmodule AtomTweaksWeb.ApiHelpers do
  @moduledoc """
  Functions for assisting with API operations.
  """

  import Plug.Conn, only: [halt: 1, send_resp: 3]

  require Logger

  @doc """
  A [function plug](https://hexdocs.pm/plug/readme.html#the-plug-conn-struct) used within a
  controller that verifies that the connection is authorized to perform the action.

  ## Examples

  Ensures that the connection has an `AtomTweaks.Accounts.Token` with the required scope:

  ```
  plug :authorize, [required_scope: "foo"] when action in [:index]
  ```
  """
  def authorize(conn, options) do
    scope = options[:required_scope]
    token = conn.assigns[:auth_token]

    if scope in token.scopes do
      conn
    else
      Logger.info("Unauthorized: Token doesn't have the required scope",
        scope: scope,
        token: token
      )

      conn
      |> send_resp(:forbidden, "403 Forbidden")
      |> halt()
    end
  end
end
