defmodule AtomStyleTweaksWeb.PageController.Spec do
  use ESpec.Phoenix, controller: AtomStyleTweaksWeb.PageController, async: true

  describe "home page" do
    let :request_path, do: page_path(build_conn(), :index, request_params())
    let :request_params, do: []
    let :user, do: build(:user)
    let :response, do: get(build_conn(), request_path())

    it "renders the index.html template" do
      expect(response()).to render_template("index.html")
    end

    it "assigns no current_user" do
      expect(response()).to have_in_assigns(current_user: nil)
    end

    it "assigns an empty tweaks list" do
      expect(response()).to have_in_assigns(tweaks: [])
    end

    it "assigns an empty params list" do
      expect(response()).to have_in_assigns(params: %{})
    end

    context "when a user is logged in" do
      let :response do
        build_conn()
        |> log_in_as(user())
        |> get(request_path())
      end

      it "assigns a current user" do
        expect(response()).to have_in_assigns(current_user: user())
      end
    end

    context "when tweaks exist in the database" do
      let! :tweaks, do: insert_list(3, :tweak)

      it "assigns them to the tweaks list" do
        expect(response().assigns.tweaks).to have_count(3)

        Enum.each(tweaks(), fn(tweak) ->
          expect(response().assigns.tweaks).to have(tweak)
        end)
      end
    end

    context "when the styles tab is selected" do
      before do
        insert(:tweak, type: "init")
      end

      let :request_params, do: [type: :style]
      let! :tweak, do: insert(:tweak, type: "style")

      it "only assigns style tweaks to the tweaks list" do
        expect(response().assigns.tweaks).to have_count(1)
        expect(response().assigns.tweaks).to have(tweak())
      end
    end

    context "when the init tab is selected" do
      before do
        insert(:tweak, type: "style")
      end

      let :request_params, do: [type: :init]
      let! :tweak, do: insert(:tweak, type: "init")

      it "only assigns init tweaks to the tweaks list" do
        expect(response().assigns.tweaks).to have_count(1)
        expect(response().assigns.tweaks).to have(tweak())
      end
    end

    # --- Specs below here are to become view specs ---

    it "shows the home page link" do
      expect(response()).to have_text_in("a.masthead-logo", "Atom Tweaks")
      expect(response()).to have_attributes_in("a.masthead-logo", href: request_path())
    end

    it "does not show the New Tweak button" do
      expect(response()).to_not have_selector("a#new-tweak-button")
    end

    it "shows the About page link" do
      expect(response()).to have_text_in("footer a#about-link", "About")
      expect(response()).to have_attributes_in("footer a#about-link", href: page_path(build_conn(), :about))
    end

    it "shows the GitHub link" do
      expect(response()).to have_attributes_in("footer a#github-link", href: "https://github.com/lee-dohm/atom-style-tweaks")
    end

    describe "when the Styles tab is selected" do
      let :request_params, do: [type: :style]

      it "shows only Style tweaks" do
        insert(:tweak, title: "Init Tweak", type: "init")
        insert(:tweak, title: "Style Tweak", type: "style")

        expect(response()).to have_text_in("a.title", "Style Tweak")
        expect(response()).to_not have_text_in("a.title", "Init Tweak")
      end
    end

    describe "when the Init tab is selected" do
      let :request_params, do: [type: :init]

      it "shows only Init tweaks" do
        insert(:tweak, title: "Init Tweak", type: "init")
        insert(:tweak, title: "Style Tweak", type: "style")

        expect(response()).to_not have_text_in("a.title", "Style Tweak")
        expect(response()).to have_text_in("a.title", "Init Tweak")
      end
    end

    describe "when logged in" do
      let :user, do: build(:user)

      let :response do
        build_conn()
        |> log_in_as(user())
        |> get(request_path())
      end

      it "shows the new tweak button" do
        expect(response()).to have_text_in("a#new-tweak-button", "New tweak")
      end
    end
  end

  describe "About page" do
    let :response, do: get(build_conn(), page_path(build_conn(), :about))

    it "displays some about text" do
      expect(response()).to have_text_in("main h1", "About Atom Tweaks")
    end
  end
end
