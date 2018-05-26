defmodule AtomStyleTweaksWeb.SlidingSessionTimeoutTest do
  use AtomStyleTweaksWeb.ConnCase

  alias AtomStyleTweaksWeb.SlidingSessionTimeout

  def timeout_at(conn), do: Plug.Conn.get_session(conn, :timeout_at)
  def now, do: DateTime.to_unix(DateTime.utc_now())

  describe "init" do
    test "defaults to a one hour timeout", _context do
      assert SlidingSessionTimeout.init() == [timeout: 3_600]
    end

    test "allows the timeout to be overridden", _context do
      assert SlidingSessionTimeout.init(timeout: 4_000) == [timeout: 4_000]
    end

    test "allows other options to be specified", _context do
      assert SlidingSessionTimeout.init(foo: "bar") == [timeout: 3_600, foo: "bar"]
    end
  end

  describe "when a timeout exists in the config" do
    setup do
      Application.put_env(:atom_style_tweaks, SlidingSessionTimeout, [timeout: 5_000])

      on_exit fn ->
        Application.put_env(:atom_style_tweaks, SlidingSessionTimeout, nil)
      end
    end

    test "uses the configuration value", _context do
      assert SlidingSessionTimeout.init() == [timeout: 5_000]
    end
  end

  describe "call" do
    test "sets the correct timeout value when no timeout exists in the session", context do
      timeout =
        context.conn
        |> Plug.Test.init_test_session(%{})
        |> get("/")
        |> timeout_at()

      assert_in_delta timeout, now() + 3_600, 2
    end

    test "renews the timeout when the timeout value exists but hasn't timed out", context do
      timeout =
        context.conn
        |> Plug.Test.init_test_session(%{timeout_at: now() + 1_000})
        |> get("/")
        |> timeout_at()

      assert_in_delta timeout, now() + 3_600, 2
    end

    test "does the needful when the session is timed out", context do
      conn =
        context.conn
        |> Plug.Test.init_test_session(%{current_user: "foo", timeout_at: now() - 1_000})
        |> get("/")

      timeout = timeout_at(conn)

      assert timeout == nil
      assert Plug.Conn.get_session(conn, :current_user) == nil
      assert conn.assigns.timed_out?
    end
  end
end
