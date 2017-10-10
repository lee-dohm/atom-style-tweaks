defmodule AtomStyleTweaksWeb.PageMetadata.Spec do
  use ESpec.Phoenix
  use Phoenix.HTML

  alias AtomStyleTweaksWeb.PageMetadata

  import Phoenix.ConnTest

  @endpoint AtomStyleTweaksWeb.Endpoint

  describe "set" do
    let! :original_site_name, do: Application.get_env(:atom_style_tweaks, :site_name)

    let :additional_metadata, do: %{}
    let :metadata do
      conn = build_conn()
             |> get("/")
             |> PageMetadata.set(additional_metadata())

      conn.assigns.page_metadata
    end

    finally do: Application.put_env(:atom_style_tweaks, :site_name, original_site_name())

    it do: expect(metadata()[:"og:url"]).to eq("http://www.example.com/")
    it do: expect(metadata()[:"og:site_name"]).to eq("Atom Tweaks")

    context "when the site name is changed in the application configuration" do
      before do: Application.put_env(:atom_style_tweaks, :site_name, "Test Name")

      it do: expect(metadata()[:"og:site_name"]).to eq("Test Name")
    end

    context "when additional metadata is set" do
      let :additional_metadata, do: %{foo: "bar", "og:site_name": "Test Name"}

      it "can be found in the page metadata" do
        expect(metadata()[:foo]).to eq("bar")
      end

      it "can override built-in metadata" do
        expect(metadata()[:"og:site_name"]).to eq("Test Name")
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
        |> PageMetadata.set(%{})
        |> PageMetadata.render()
      end

      it "emits the expected tags" do
        expect(render()).to eq([
          tag(:meta, property: :"og:site_name", content: "Atom Tweaks"),
          tag(:meta, property: :"og:url", content: "http://www.example.com/")
        ])
      end
    end
  end
end
