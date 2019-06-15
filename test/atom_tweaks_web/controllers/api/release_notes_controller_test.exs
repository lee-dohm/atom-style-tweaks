defmodule AtomTweaksWeb.Api.ReleaseNotesControllerTest do
  use AtomTweaksWeb.ApiCase

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
