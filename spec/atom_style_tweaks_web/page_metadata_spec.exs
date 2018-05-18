defmodule AtomStyleTweaksWeb.PageMetadata.Spec do
  use ESpec.Phoenix
  use Phoenix.HTML

  alias AtomStyleTweaksWeb.PageMetadata

  import Phoenix.ConnTest

  @endpoint AtomStyleTweaksWeb.Endpoint

  describe "add" do
    let! :original_site_name, do: Application.get_env(:atom_style_tweaks, :site_name)

    let :metadata, do: test_conn().assigns[:page_metadata]

    let :test_conn do
      build_conn()
      |> get("/")
      |> PageMetadata.add(additional_metadata())
    end

    context "when no metadata is added" do
      let :test_conn do
        build_conn()
        |> get("/")
      end

      it "has no metadata" do
        expect(metadata()).to eq(nil)
      end
    end

    context "when nil metadata is added" do
      let :additional_metadata, do: nil

      it "has no metadata" do
        expect(metadata()).to eq(nil)
      end
    end

    context "when empty metadata is added" do
      let :additional_metadata, do: []

      it "has some default values" do
        expect(metadata()).to have_count(2)
        expect(metadata()).to have([property: "og:url", content: "http://www.example.com/"])
        expect(metadata()).to have([property: "og:site_name", content: "Atom Tweaks"])
      end
    end

    context "when an additional datum is added" do
      let :additional_metadata, do: [property: "og:title", content: "Test title"]

      it "has the defaults plus the added metadata" do
        expect(metadata()).to have_count(3)
        expect(metadata()).to have([property: "og:url", content: "http://www.example.com/"])
        expect(metadata()).to have([property: "og:site_name", content: "Atom Tweaks"])
        expect(metadata()).to have([property: "og:title", content: "Test title"])
      end
    end

    context "when a list of data is added" do
      let :additional_metadata do
        [[property: "og:title", content: "Test title"], [foo: "bar", bar: "baz"]]
      end

      it "has the defaults plus the added metadata" do
        expect(metadata()).to have_count(4)
        expect(metadata()).to have([foo: "bar", bar: "baz"])
        expect(metadata()).to have([property: "og:url", content: "http://www.example.com/"])
        expect(metadata()).to have([property: "og:site_name", content: "Atom Tweaks"])
        expect(metadata()).to have([property: "og:title", content: "Test title"])
      end
    end
  end

  describe "render" do
    context "when there is no page metadata" do
      let :render do
        build_conn()
        |> get("/")
        |> PageMetadata.render()
      end

      it "returns nil" do
        expect(render()).to eq(nil)
      end
    end

    context "when page metadata has been set" do
      let :render do
        build_conn()
        |> get("/")
        |> PageMetadata.add([])
        |> PageMetadata.render
      end

      it "emits the expected tags" do
        expect(render()).to have(tag(:meta, property: :"og:site_name", content: "Atom Tweaks"))
        expect(render()).to have(tag(:meta, property: :"og:url", content: "http://www.example.com/"))
      end
    end
  end
end
