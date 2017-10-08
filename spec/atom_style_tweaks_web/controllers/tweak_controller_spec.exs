defmodule AtomStyleTweaksWeb.TweakController.Spec do
  use ESpec.Phoenix, controller: AtomStyleTweaksWeb.TweakController, async: true

  let :user, do: insert(:user)
  let :tweak, do: insert(:tweak, user: user())

  describe "create tweak" do
    let :request_params, do: %{"name" => user_name(), "tweak" => tweak_params()}
    let :request_path, do: user_tweak_path(build_conn(), :create, user_name())
    let :user_name, do: user().name
    let :tweak_params, do: params_for(:tweak)

    context "when not logged in" do
      let :response, do: post(build_conn(), request_path(), request_params())

      it "returns unauthorized" do
        expect(response()).to have_http_status(:unauthorized)
      end
    end

    context "when logged in" do
      let :response do
        build_conn()
        |> log_in_as(user())
        |> post(request_path(), request_params())
      end

      it "succeeds" do
        expect(response()).to redirect_to_match(~r{^/users/#{user_name()}/tweaks/})
      end

      context "with invalid tweak parameters" do
        let :tweak_params, do: params_for(:tweak, title: "")

        it "renders the new tweak template" do
          expect(response()).to render_template("new.html")
        end
      end

      context "with an invalid user name for the tweak" do
        let :user_name, do: build(:user).name

        it "returns not found" do
          expect(response()).to have_http_status(:not_found)
        end
      end

      context "with a different user id than the one for the tweak" do
        let :response do
          build_conn()
          |> log_in_as(insert(:user))
          |> post(request_path(), request_params())
        end

        it "returns not found" do
          expect(response()).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "new tweak" do
    let :request_path, do: user_tweak_path(build_conn(), :new, user())

    context "when not logged in" do
      let :response, do: get(build_conn(), request_path())

      it "returns unauthorized" do
        expect(response()).to have_http_status(:unauthorized)
      end
    end

    context "when logged in" do
      let :response do
        build_conn()
        |> log_in_as(user())
        |> get(request_path())
      end

      it "has a tweak title input element" do
        expect(response()).to have_attributes_in("input#tweak_title", placeholder: "Title")
      end

      it "has a tweak type select element" do
        expect(response()).to have_selector("select#tweak_type")
      end

      it "has a tweak code text area element" do
        expect(response()).to have_attributes_in("textarea#tweak_code", placeholder: "Enter tweak code")
      end

      it "has a tweak description text area element" do
        expect(response()).to have_attributes_in("textarea#tweak_description", placeholder: "Describe the tweak")
      end

      it "has a submit button" do
        expect(response()).to have_text_in("button.btn.btn-primary", "Save new tweak")
        expect(response()).to have_attributes_in("button.btn.btn-primary", type: "submit")
      end

      context "and requesting a new tweak for an invalid user" do
        let :request_path, do: user_tweak_path(build_conn(), :new, build(:user))

        it "returns not found" do
          expect(response()).to have_http_status(:not_found)
        end
      end

      context "as a different user" do
        let :response do
          build_conn()
          |> log_in_as(insert(:user))
          |> get(request_path())
        end

        it "returns not found" do
          expect(response()).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "edit tweak" do
    let :request_path, do: user_tweak_path(build_conn(), :edit, tweak().user.name, tweak().id)

    context "when not logged in" do
      let :response, do: get(build_conn(), request_path())

      it "returns unauthorized" do
        expect(response()).to have_http_status(:unauthorized)
      end
    end

    context "when logged in" do
      let :response do
        build_conn()
        |> log_in_as(user())
        |> get(request_path())
      end

      it "has a tweak title input element" do
        expect(response()).to have_attributes_in("input#tweak_title", placeholder: "Title")
      end

      it "has a tweak type select element" do
        expect(response()).to have_selector("select#tweak_type")
      end

      it "has a tweak code text area element" do
        expect(response()).to have_attributes_in("textarea#tweak_code", placeholder: "Enter tweak code")
      end

      it "has a tweak description text area element" do
        expect(response()).to have_attributes_in("textarea#tweak_description", placeholder: "Describe the tweak")
      end

      it "has a submit button" do
        expect(response()).to have_text_in("button.btn.btn-primary", "Update tweak")
        expect(response()).to have_attributes_in("button.btn.btn-primary", type: "submit")
      end

      it "has a cancel button" do
        expect(response()).to have_text_in("a.btn.btn-danger", "Cancel")
        expect(response()).to have_attributes_in("a.btn.btn-danger", href: user_tweak_path(build_conn(), :show, tweak().user.name, tweak().id))
      end

      context "as a different user" do
        let :response do
          build_conn()
          |> log_in_as(insert(:user))
          |> get(request_path())
        end

        it "returns not found" do
          expect(response()).to have_http_status(:not_found)
        end
      end

      context "and editing a tweak with an invalid user name" do
        let :request_path, do: user_tweak_path(build_conn(), :edit, build(:user).name, tweak().id)

        it "returns not found" do
          expect(response()).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "show tweak" do
    let :request_path, do: user_tweak_path(build_conn(), :show, tweak().user.name, tweak().id)
    let :response, do: get(build_conn(), request_path())

    it "displays the tweak's title" do
      expect(response()).to have_text_in("main h3", tweak().title)
    end

    it "displays the tweak's code" do
      expect(response()).to have_text_in("code", tweak().code)
    end

    it "displays the tweak's description" do
      expect(response()).to have_text_in(".tweak-description", tweak().description)
    end

    it "does not show the edit button" do
      expect(response()).to_not have_selector("a#edit-button")
    end

    context "when logged in" do
      let :response do
        build_conn()
        |> log_in_as(tweak().user)
        |> get(request_path())
      end

      it "shows the edit button" do
        expect(response()).to have_selector("a#edit-button")
      end

      context "as a user that does not own the tweak" do
        let :response do
          build_conn()
          |> log_in_as(insert(:user))
          |> get(request_path())
        end

        it "does not show the edit button" do
          expect(response()).to_not have_selector("a#edit-button")
        end
      end
    end
  end
end
