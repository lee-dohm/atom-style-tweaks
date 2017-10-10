defmodule AtomStyleTweaksWeb.HerokuMetadata.Spec do
  use ESpec.Phoenix, async: true

  alias AtomStyleTweaksWeb.HerokuMetadata

  describe "HerokuMetadata" do
    before do
      heroku_metadata = Application.get_env(:atom_style_tweaks, HerokuMetadata)
      keys = Keyword.keys(heroku_metadata)
      test_data = Enum.map(keys, fn(key) -> {key, Atom.to_string(key) <> " test"} end)
      Application.put_env(:atom_style_tweaks, HerokuMetadata, test_data)

      {:shared, original: heroku_metadata}
    end

    finally do: Application.put_env(:atom_style_tweaks, HerokuMetadata, shared.original)

    it do: expect(HerokuMetadata.app_id()).to eq("app_id test")
    it do: expect(HerokuMetadata.app_name()).to eq("app_name test")
    it do: expect(HerokuMetadata.dyno_id()).to eq("dyno_id test")
    it do: expect(HerokuMetadata.release_created_at()).to eq("release_created_at test")
    it do: expect(HerokuMetadata.release_version()).to eq("release_version test")
    it do: expect(HerokuMetadata.slug_commit()).to eq("slug_commit test")
    it do: expect(HerokuMetadata.slug_description()).to eq("slug_description test")

    describe "on_heroku?" do
      context "when dyno ID is set" do
        it "returns a truthy value" do
          expect(HerokuMetadata.on_heroku?()).to be_true()
        end
      end

      context "when dyno ID is not set" do
        before do
          metadata = Application.get_env(:atom_style_tweaks, HerokuMetadata)
          test_data = Keyword.delete(metadata, :dyno_id)

          Application.put_env(:atom_style_tweaks, HerokuMetadata, test_data)
        end

        it "returns a falsy value" do
          expect(HerokuMetadata.on_heroku?()).to be_false()
        end
      end
    end
  end
end
