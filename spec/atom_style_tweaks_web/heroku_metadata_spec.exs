defmodule AtomStyleTweaksWeb.HerokuMetadata.Spec do
  use ESpec.Phoenix

  alias AtomStyleTweaksWeb.HerokuMetadata

  describe "HerokuMetadata" do
    let :metadata, do: HerokuMetadata.get(params())
    let :params, do: []

    before do
      Enum.each(environment_variable_names(), fn(name) ->
        System.put_env(name, "#{name} test")
      end)
    end

    finally do: Enum.each(environment_variable_names(), fn(name) -> System.delete_env(name) end)

    context "when not on Heroku" do
      let :environment_variable_names, do: []

      describe "get" do
        it "does not return metadata" do
          expect(metadata()).to eq(nil)
        end
      end
    end

    context "when on Heroku" do
      let :environment_variable_names do
        [
          "HEROKU_APP_ID",
          "HEROKU_APP_NAME",
          "HEROKU_DYNO_ID",
          "HEROKU_RELEASE_CREATED_AT",
          "HEROKU_RELEASE_VERSION",
          "HEROKU_SLUG_COMMIT",
          "HEROKU_SLUG_DESCRIPTION"
        ]
      end

      describe "get" do
        it "returns a list of metadata in PageMetadata form" do
          expect(metadata()).to have_count(7)
          expect(metadata()).to have([name: "HEROKU_APP_ID", content: "HEROKU_APP_ID test"])
          expect(metadata()).to have([name: "HEROKU_APP_NAME", content: "HEROKU_APP_NAME test"])
          expect(metadata()).to have([name: "HEROKU_DYNO_ID", content: "HEROKU_DYNO_ID test"])
          expect(metadata()).to have([name: "HEROKU_RELEASE_CREATED_AT", content: "HEROKU_RELEASE_CREATED_AT test"])
          expect(metadata()).to have([name: "HEROKU_RELEASE_VERSION", content: "HEROKU_RELEASE_VERSION test"])
          expect(metadata()).to have([name: "HEROKU_SLUG_COMMIT", content: "HEROKU_SLUG_COMMIT test"])
          expect(metadata()).to have([name: "HEROKU_SLUG_DESCRIPTION", content: "HEROKU_SLUG_DESCRIPTION test"])
        end

        context "when only is given" do
          let :params, do: [only: ["HEROKU_APP_ID", "HEROKU_APP_NAME"]]

          it "returns only the variables specified" do
            expect(metadata()).to have_count(2)
            expect(metadata()).to have([name: "HEROKU_APP_ID", content: "HEROKU_APP_ID test"])
            expect(metadata()).to have([name: "HEROKU_APP_NAME", content: "HEROKU_APP_NAME test"])
          end
        end

        context "when except is given" do
          let :params, do: [except: ["HEROKU_APP_ID", "HEROKU_APP_NAME"]]

          it "returns all of the variables except the ones specified" do
            expect(metadata()).to have_count(5)
            expect(metadata()).to have([name: "HEROKU_DYNO_ID", content: "HEROKU_DYNO_ID test"])
            expect(metadata()).to have([name: "HEROKU_RELEASE_CREATED_AT", content: "HEROKU_RELEASE_CREATED_AT test"])
            expect(metadata()).to have([name: "HEROKU_RELEASE_VERSION", content: "HEROKU_RELEASE_VERSION test"])
            expect(metadata()).to have([name: "HEROKU_SLUG_COMMIT", content: "HEROKU_SLUG_COMMIT test"])
            expect(metadata()).to have([name: "HEROKU_SLUG_DESCRIPTION", content: "HEROKU_SLUG_DESCRIPTION test"])
          end
        end
      end
    end
  end
end
