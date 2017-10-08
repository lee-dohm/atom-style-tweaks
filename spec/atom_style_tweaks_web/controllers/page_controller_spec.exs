defmodule AtomStyleTweaksWeb.PageController.Spec do
  use ESpec.Phoenix, controller: AtomStyleTweaksWeb.PageController, async: true

  describe "home page" do
    def home_page(), do: page_path(build_conn(), :index)
    def home_page(params), do: page_path(build_conn(), :index, params)

    let :response, do: get(build_conn(), home_page())

    it "shows the home page link" do
      expect(response()).to have_text_in("a.masthead-logo", "Atom Tweaks")
      expect(response()).to have_attributes_in("a.masthead-logo", href: home_page())
    end

    it "shows All tab" do
      expect(response()).to have_text_in("a#all-menu-item", "All")
      expect(response()).to have_attributes_in("a#all-menu-item", href: home_page())
    end

    it "shows the beaker octicon for the All tab" do
      expect(response()).to have_selector("a#all-menu-item > .octicons.octicons-beaker")
    end

    it "marks All tab selected and the others unselected" do
      expect(response()).to have_selector("a#all-menu-item.selected")
      expect(response()).to_not have_selector("a#styles-menu-item.selected")
      expect(response()).to_not have_selector("a#init-menu-item.selected")
    end

    it "shows Styles tab" do
      expect(response()).to have_text_in("a#styles-menu-item", "Styles")
      expect(response()).to have_attributes_in("a#styles-menu-item", href: home_page(type: :style))
    end

    it "shows the paint can octicon for the Styles tab" do
      expect(response()).to have_selector("a#styles-menu-item > .octicons.octicons-paintcan")
    end

    it "shows Init tab" do
      expect(response()).to have_text_in("a#init-menu-item", "Init")
      expect(response()).to have_attributes_in("a#init-menu-item", href: home_page(type: :init))
    end

    it "shows the code octicon for the Init tab" do
      expect(response()).to have_selector("a#init-menu-item > .octicons.octicons-code")
    end

    it "does not show the New Tweak button" do
      expect(response()).to_not have_selector("a#new-tweak-button")
    end

    it "shows a list of tweaks" do
      tweaks = insert_list(3, :tweak)

      Enum.each(tweaks, fn(tweak) ->
        expect(response()).to have_text_in("a.title", tweak.title)
        expect(response()).to have_attributes_in("a.title", href: user_tweak_path(build_conn(), :show, tweak.user.name, tweak.id))
      end)
    end

    it "shows the About page link" do
      expect(response()).to have_text_in("footer a#about-link", "About")
      expect(response()).to have_attributes_in("footer a#about-link", href: page_path(build_conn(), :about))
    end

    it "shows the GitHub link" do
      expect(response()).to have_attributes_in("footer a#github-link", href: "https://github.com/lee-dohm/atom-style-tweaks")
    end

    describe "when the Styles tab is selected" do
      let :response, do: get(build_conn(), home_page(type: :style))

      it "marks the Styles tab selected and the others unselected" do
        expect(response()).to_not have_selector("a#all-menu-item.selected")
        expect(response()).to have_selector("a#styles-menu-item.selected")
        expect(response()).to_not have_selector("a#init-menu-item.selected")
      end

      it "shows only Style tweaks" do
        insert(:tweak, title: "Init Tweak", type: "init")
        insert(:tweak, title: "Style Tweak", type: "style")

        expect(response()).to have_text_in("a.title", "Style Tweak")
        expect(response()).to_not have_text_in("a.title", "Init Tweak")
      end
    end

    describe "when the Init tab is selected" do
      let :response, do: get(build_conn(), home_page(type: :init))

      it "marks the Init tab selected and the others unselected" do
        expect(response()).to_not have_selector("a#all-menu-item.selected")
        expect(response()).to_not have_selector("a#styles-menu-item.selected")
        expect(response()).to have_selector("a#init-menu-item.selected")
      end

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
        |> get(home_page())
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
