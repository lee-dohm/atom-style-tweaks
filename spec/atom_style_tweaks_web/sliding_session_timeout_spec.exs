defmodule AtomStyleTweaksWeb.SlidingSessionTimeout.Spec do
  use ESpec.Phoenix

  alias AtomStyleTweaksWeb.SlidingSessionTimeout

  import Phoenix.ConnTest
  import Plug.Conn
  import Plug.Test

  @endpoint AtomStyleTweaksWeb.Endpoint

  describe "init" do
    it "defaults to a one hour timeout" do
      expect(SlidingSessionTimeout.init()).to eq([timeout: 3_600])
    end

    it "allows the timeout to be overridden" do
      expect(SlidingSessionTimeout.init(timeout: 4_000)).to eq([timeout: 4_000])
    end

    it "allows other options to be specified" do
      expect(SlidingSessionTimeout.init(foo: "bar")).to eq([timeout: 3_600, foo: "bar"])
    end

    context "when a timeout exists in the config" do
      before do
        Application.put_env(:atom_style_tweaks, SlidingSessionTimeout, [timeout: 5_000])
      end

      finally do
        Application.put_env(:atom_style_tweaks, SlidingSessionTimeout, nil)
      end

      it "uses the configuration value" do
        expect(SlidingSessionTimeout.init()).to eq([timeout: 5_000])
      end
    end
  end

  describe "call" do
    let :now, do: DateTime.to_unix(DateTime.utc_now())

    let :response do
      SlidingSessionTimeout.init([timeout: 3_600])

      build_conn()
      |> init_test_session(session_data())
      |> get("/")
    end

    let :timeout_at, do: get_session(response(), :timeout_at)

    context "when no timeout value exists in the session" do
      let :session_data, do: %{}

      it "sets the timeout to now plus the timeout value" do
        expect(timeout_at()).to be_close_to(now() + 3_600, 2)
      end
    end

    context "when a value exists but hasn't timeed out" do
      let :session_data, do: %{timeout_at: now() + 1_000}

      it "renews the timeout" do
        expect(timeout_at()).to be_close_to(now() + 3_600, 2)
      end
    end

    context "when the session is timed out" do
      let :current_user, do: get_session(response(), :current_user)
      let :session_data, do: %{timeout_at: now() - 1_000}

      it "clears the timeout_at value" do
        expect(timeout_at()).to eq(nil)
      end

      it "clears the current user value" do
        expect(current_user()).to eq(nil)
      end

      it "sets timed_out? to true" do
        expect(response().assigns.timed_out?).to eq(true)
      end
    end
  end
end
