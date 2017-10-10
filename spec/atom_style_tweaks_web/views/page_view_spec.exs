defmodule AtomStyleTweaksWeb.PageView.Spec do
  use ESpec.Phoenix, view: AtomStyleTweaksWeb.PageView, async: true

  let :all_tweaks_path, do: page_path(build_conn(), :index)
  let :assigns, do: [conn: build_conn(), params: params(), current_user: user(), tweaks: tweaks()]
  let :init_tweaks_path, do: page_path(build_conn(), :index, type: :init)
  let :params, do: %{}
  let :style_tweaks_path, do: page_path(build_conn(), :index, type: :style)
  let :tweaks, do: []
  let :user, do: nil

  describe "index.html" do
    let :content, do: render_template("index.html", assigns())

    describe "navigation menu" do
      it "has a navigation menu" do
        expect(content()).to have_selector("nav.menu")
      end

      it "shows the All tab" do
        expect(content()).to have_text_in("a#all-menu-item", "All")
        expect(content()).to have_attributes_in("a#all-menu-item", href: all_tweaks_path())
      end

      it "shows Styles tab" do
        expect(content()).to have_text_in("a#styles-menu-item", "Styles")
        expect(content()).to have_attributes_in("a#styles-menu-item", href: style_tweaks_path())
      end

      it "shows the Init tab" do
        expect(content()).to have_text_in("a#init-menu-item", "Init")
        expect(content()).to have_attributes_in("a#init-menu-item", href: init_tweaks_path())
      end

      it "marks the All tab selected and deselects the others" do
        expect(content()).to have_selector("a#all-menu-item.selected")
        expect(content()).to_not have_selector("a#init-menu-item.selected")
        expect(content()).to_not have_selector("a#styles-menu-item.selected")
      end

      context "when init tweaks are selected" do
        let :params, do: %{"type" => "init"}

        it "marks the Init tab selected and deselects the others" do
          expect(content()).to_not have_selector("a#all-menu-item.selected")
          expect(content()).to have_selector("a#init-menu-item.selected")
          expect(content()).to_not have_selector("a#styles-menu-item.selected")
        end
      end

      context "when style tweaks are selected" do
        let :params, do: %{"type" => "style"}

        it "marks the Styles tab selected and deselects the others" do
          expect(content()).to_not have_selector("a#all-menu-item.selected")
          expect(content()).to_not have_selector("a#init-menu-item.selected")
          expect(content()).to have_selector("a#styles-menu-item.selected")
        end
      end
    end
  end
end
