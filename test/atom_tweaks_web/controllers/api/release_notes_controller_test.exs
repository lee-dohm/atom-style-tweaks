defmodule AtomTweaksWeb.Api.ReleaseNotesControllerTest do
  use AtomTweaksWeb.ApiCase

  alias AtomTweaks.Accounts.Token

  setup(context) do
    conn = put_req_header(context.conn, "authorization", "token #{Token.to_code(insert(:token))}")

    {:ok, conn: conn}
  end

  describe "POST create" do
    test "returns created status when given valid params", context do
      params = json_params_for(:note)

      conn = post(context.conn, "/api/release-notes", params)

      assert json_response(conn, :created) == ""
    end

    test "returns bad request status when given invalid params", context do
      params = json_params_for(:note, description: "", detail_url: "", title: "")

      conn = post(context.conn, "/api/release-notes", params)

      assert json_response(conn, :bad_request) == ""
    end
  end
end
