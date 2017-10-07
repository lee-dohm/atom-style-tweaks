defmodule AtomStyleTweaksWeb.AuthController.Spec do
  use ESpec.Phoenix, controller: AtomStyleTweaksWeb.AuthController, async: true
  import CustomAssertions

  describe "index" do
    it "redirects to the GitHub authorization URL" do
      conn = get(build_conn(), auth_path(build_conn(), :index))

      expect(conn).to redirect_to("https://github.com/login/oauth/authorize?client_id=&redirect_uri=&response_type=code&scope=read%3Aorg")
    end

    it "saves the return to path in the session" do
      conn = get(build_conn(), auth_path(build_conn(), :index, %{"from" => "/foo/bar/baz"}))

      expect(conn).to have_in_session(:return_to, "/foo/bar/baz")
    end
  end
end
