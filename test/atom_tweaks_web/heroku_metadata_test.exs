defmodule AtomTweaksWeb.HerokuMetadataTest do
  use ExUnit.Case

  alias AtomTweaksWeb.HerokuMetadata

  describe "when not on Heroku" do
    test "does not return any metadata", _context do
      refute HerokuMetadata.get()
    end
  end

  describe "when on Heroku" do
    setup do
      environment_variable_names = [
        "HEROKU_APP_ID",
        "HEROKU_APP_NAME",
        "HEROKU_DYNO_ID",
        "HEROKU_RELEASE_CREATED_AT",
        "HEROKU_RELEASE_VERSION",
        "HEROKU_SLUG_COMMIT",
        "HEROKU_SLUG_DESCRIPTION"
      ]

      Enum.each(environment_variable_names, fn name ->
        System.put_env(name, "#{name} test")
      end)

      on_exit(fn ->
        Enum.each(environment_variable_names, fn name -> System.delete_env(name) end)
      end)

      {:ok, env_names: environment_variable_names}
    end

    test "returns a list of metadata in PageMetadata form", context do
      metadata = HerokuMetadata.get()

      assert length(metadata) == 7

      assert Enum.all?(context.env_names, fn name ->
               Enum.member?(metadata, name: name, content: "#{name} test")
             end)
    end

    test "when only is given", _context do
      only = ["HEROKU_APP_ID", "HEROKU_APP_NAME"]
      metadata = HerokuMetadata.get(only: only)

      assert length(metadata) == 2

      assert Enum.all?(only, fn name ->
               Enum.member?(metadata, name: name, content: "#{name} test")
             end)
    end

    test "when except is given", _context do
      except = ["HEROKU_APP_ID", "HEROKU_APP_NAME"]
      metadata = HerokuMetadata.get(except: except)

      assert length(metadata) == 5

      assert Enum.all?(except, fn name ->
               not Enum.member?(metadata, name: name, content: "#{name} test")
             end)
    end
  end
end
