defmodule AtomStyleTweaksWeb.User.Spec do
  use ESpec.Phoenix, model: User, async: true

  alias AtomStyleTweaksWeb.User

  describe "creating a changeset" do
    let :user_attributes, do: params_for(:user, user_params())
    let :user_params, do: []
    let :subject, do: User.changeset(%User{}, user_attributes())

    context "with valid attributes" do
      it do: is_expected().to be_valid()
    end

    context "with an empty name" do
      let :user_params, do: [name: ""]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:name))
    end

    context "with a nil name" do
      let :user_params, do: [name: nil]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:name))
    end

    context "with a name that is not a string" do
      let :user_params, do: [name: 42]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(cast_error(:name, :string))
    end

    context "with a nil github_id" do
      let :user_params, do: [github_id: nil]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:github_id))
    end

    context "with a github_id that is not a number" do
      let :user_params, do: [github_id: "foo"]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(cast_error(:github_id, :integer))
    end

    context "with an empty avatar_url" do
      let :user_params, do: [avatar_url: ""]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:avatar_url))
    end

    context "with a nil avatar_url" do
      let :user_params, do: [avatar_url: nil]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:avatar_url))
    end

    context "with an avatar_url that is not a string" do
      let :user_params, do: [avatar_url: 42]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(cast_error(:avatar_url, :string))
    end

    context "with an avatar_url that is not a URL" do
      let :user_params, do: [avatar_url: "foo"]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(error(:avatar_url, "must be a valid URL", []))
    end

    context "with a site_admin value that is not a boolean" do
      let :user_params, do: [site_admin: 42]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(cast_error(:site_admin, :boolean))
    end
  end

  describe "exists?" do
    let :bad_user, do: build(:user)
    let :user, do: insert(:user)

    it "returns true when the record exists" do
      expect(User.exists?(user().name)).to be_true()
    end

    it "returns false when the record does not exist" do
      expect(User.exists?(bad_user().name)).to be_false()
    end
  end
end
