defmodule AtomStyleTweaksWeb.UserController.Spec do
  use ESpec.Phoenix, controller: AtomStyleTweaksWeb.UserController, async: true

  let :user, do: insert(:user)

  describe "show user" do
    let :request_path, do: user_path(build_conn(), :show, user().name)
    let :response, do: get(build_conn(), request_path())

    it "displays the user's name" do
      expect(response()).to have_text_in("#user-info-block h2", user().name)
    end

    it "displays the user's avatar" do
      expect(response()).to have_attributes_in("img.avatar", src: user().avatar_url <> "&s=230")
    end

    it "does not display the staff badge" do
      expect(response()).to_not have_selector("#staff-badge")
    end

    it "does not show the new tweak button" do
      expect(response()).to_not have_selector("#new-tweak-button")
    end

    it "displays a blankslate element" do
      expect(response()).to have_selector(".blankslate")
    end

    context "who is a site admin" do
      let :user, do: insert(:user, site_admin: true)

      it "displays the staff badge" do
        expect(response()).to have_selector("#staff-badge")
      end
    end

    context "who has tweaks" do
      let :tweaks, do: insert_list(3, :tweak, user: user())

      it "displays a list of tweaks" do
        Enum.each(tweaks(), fn(tweak) ->
          expect(response()).to have_text_in("a.title", tweak.title)
          expect(response()).to have_attributes_in("a.title",
            href: user_tweak_path(build_conn(), :show, tweak.user.name, tweak.id))
        end)
      end
    end

    context "when logged in" do
      let :response do
        build_conn()
        |> log_in_as(user())
        |> get(request_path())
      end

      it "displays the new tweak button" do
        expect(response()).to have_selector("#new-tweak-button")
      end

      context "as a different user" do
        let :response do
          build_conn()
          |> log_in_as(insert(:user))
          |> get(request_path())
        end

        it "does not display the new tweak button" do
          expect(response()).to_not have_selector("#new-tweak-button")
        end
      end
    end
  end
end
