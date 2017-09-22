defmodule AtomStyleTweaks.HerokuMetadata.Test do
  use ExUnit.Case, async: true

  alias AtomStyleTweaksWeb.HerokuMetadata

  setup do
    heroku_metadata = Application.get_env(:atom_style_tweaks, HerokuMetadata)
    keys = Keyword.keys(heroku_metadata)
    test_data = Enum.map(keys, fn(key) -> {key, Atom.to_string(key) <> " test"} end)
    Application.put_env(:atom_style_tweaks, HerokuMetadata, test_data)

    on_exit fn ->
      # Ensure that after every test the configuration is restored (because if you delete a key,
      # the above code won't fix it)
      Application.put_env(:atom_style_tweaks, HerokuMetadata, test_data)
    end

    :ok
  end

  test "on_heroku? returns true if dyno id is set" do
    assert HerokuMetadata.on_heroku?
  end

  test "on_heroku? returns false if dyno id is unset" do
    metadata = Application.get_env(:atom_style_tweaks, HerokuMetadata)
    test_data = Keyword.delete(metadata, :dyno_id)

    Application.put_env(:atom_style_tweaks, HerokuMetadata, test_data)

    refute HerokuMetadata.on_heroku?
  end

  test "app_id returns the expected value" do
    assert HerokuMetadata.app_id == "app_id test"
  end

  test "app_name returns the expected value" do
    assert HerokuMetadata.app_name == "app_name test"
  end

  test "dyno_id returns the expected value" do
    assert HerokuMetadata.dyno_id == "dyno_id test"
  end

  test "release_created_at returns the expected value" do
    assert HerokuMetadata.release_created_at == "release_created_at test"
  end

  test "release_version returns the expected value" do
    assert HerokuMetadata.release_version == "release_version test"
  end

  test "slug_commit returns the expected value" do
    assert HerokuMetadata.slug_commit == "slug_commit test"
  end

  test "slug_description returns the expected value" do
    assert HerokuMetadata.slug_description == "slug_description test"
  end
end
