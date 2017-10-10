defmodule AtomStyleTweaksWeb.Tweak.Spec do
  use ESpec.Phoenix, model: Tweak, async: true

  alias AtomStyleTweaksWeb.Tweak

  let :user, do: insert(:user)

  describe "creating a changeset" do
    let :tweak_attributes, do: params_for(:tweak, [user: user()] ++ tweak_params())
    let :tweak_params, do: []
    let :subject, do: Tweak.changeset(%Tweak{}, tweak_attributes())

    context "with valid attributes" do
      it do: is_expected().to be_valid()
    end

    context "with an empty title" do
      let :tweak_params, do: [title: ""]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:title))
    end

    context "with a nil title" do
      let :tweak_params, do: [title: nil]

      it do: is_expected().to_not be_valid()
    end

    context "with empty code" do
      let :tweak_params, do: [code: ""]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:code))
    end

    context "with nil code" do
      let :tweak_params, do: [code: nil]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:code))
    end

    context "with an invalid tweak type" do
      let :tweak_params, do: [type: "foo"]

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(inclusion_error(:type))
    end

    context "with an empty description" do
      let :tweak_params, do: [description: ""]

      it do: is_expected().to be_valid()
    end

    context "with a nil description" do
      let :tweak_params, do: [description: nil]

      it do: is_expected().to be_valid()
    end

    context "with an invalid user" do
      let :user, do: build(:user)

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:created_by))
    end

    context "with a nil user" do
      let :user, do: nil

      it do: is_expected().to_not be_valid()
      it do: is_expected().to have_errors(required_error(:created_by))
    end
  end
end
