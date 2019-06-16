defmodule AtomTweaksWeb.TokenAuthenticationTest do
  use AtomTweaksWeb.ApiCase

  alias AtomTweaks.Accounts.Token
  alias AtomTweaksWeb.TokenAuthentication, as: Auth

  describe "call/2" do
    test "returns unauthorized when there is no authorization header", context do
      conn = Auth.call(context.conn, nil)

      assert conn.halted
      assert text_response(conn, :unauthorized) == "401 Unauthorized"
    end

    test "returns forbidden when the authorization header is invalid", context do
      conn =
        context.conn
        |> put_req_header("authorization", "token foo")
        |> Auth.call(nil)

      assert conn.halted
      assert text_response(conn, :forbidden) == "403 Forbidden"
    end

    test "assigns the auth token when the authorization header is valid", context do
      code =
        :token
        |> insert()
        |> Token.to_code()

      conn =
        context.conn
        |> put_req_header("authorization", "token #{code}")
        |> Auth.call(nil)

      refute conn.halted
      assert conn.assigns[:auth_token]
    end
  end
end
