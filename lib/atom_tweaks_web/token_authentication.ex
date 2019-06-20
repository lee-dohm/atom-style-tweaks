defmodule AtomTweaksWeb.TokenAuthentication do
  @moduledoc """
  A `Plug` that authenticates an API connection based on the contents of the `authorization` header.

  The plug retrieves a `Phoenix.Token`-generated code from the `authorization` request header.
  If that code resolves to a valid `AtomTweaks.Accounts.Token`, then the token is stored in the
  [connection assigns](https://hexdocs.pm/plug/Plug.Conn.html#module-connection-fields) under the
  `:auth_token` key. It expects the header to be of the format:

  ```text
  authorization: token [gigantically long token here]
  ```

  Keep in mind that [HTTP header keys are case-insensitive][case-insensitive].

  [case-insensitive]: https://stackoverflow.com/questions/5258977/are-http-headers-case-sensitive

  Otherwise, if the header is missing or malformatted, a `401 Unauthorized` response is returned. If
  the header is present and properly formatted, but the code does not resolve to a valid token, then
  a `403 Forbidden` response is returned.

  This only authenticates the connection, ensuring that it has a valid `AtomTweaks.Accounts.Token`.
  Each individual controller must ensure that the token contains the proper authorization to perform
  the action that is being requested. See `AtomTweaksWeb.ApiHelpers.authorize/2` for more details.

  ## Examples

  ```
  pipeline :api do
    plug(:accepts, ["json"])
    plug(AtomTweaksWeb.TokenAuthentication)
  end
  ```
  """

  alias AtomTweaks.Accounts

  import Plug.Conn

  require Logger

  @doc false
  def init(_options), do: nil

  @doc false
  def call(conn, _options) do
    maybe_token =
      conn
      |> get_auth_header()
      |> get_token_code()
      |> get_token()

    case maybe_token do
      {:ok, token} ->
        assign(conn, :auth_token, token)

      {:error, :missing} ->
        Logger.info("Missing or malformed authorization header")

        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(:unauthorized, "401 Unauthorized")
        |> halt()

      {:error, err} ->
        Logger.info("Unauthorized: #{err}")

        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(:forbidden, "403 Forbidden")
        |> halt()
    end
  end

  defp get_auth_header(conn), do: get_req_header(conn, "authorization")

  defp get_token_code(["token " <> rest]), do: rest
  defp get_token_code(_), do: nil

  defp get_token(nil), do: {:error, :missing}
  defp get_token(code), do: Accounts.get_token(code)
end
