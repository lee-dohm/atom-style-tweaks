defmodule AtomTweaks.AccountsTest do
  use AtomTweaks.DataCase

  import Support.Setup

  alias AtomTweaks.Accounts
  alias AtomTweaks.Accounts.Token

  describe "stars" do
    setup [:insert_tweak]

    test "star a tweak", context do
      {:ok, star} = Accounts.star_tweak(context.user, context.tweak)
      stars = Accounts.list_stars(context.user)

      assert length(stars) == 1
      assert star.user_id == context.user.id
      assert star.tweak_id == context.tweak.id
    end

    test "unstar a tweak", context do
      {:ok, _} = Accounts.star_tweak(context.user, context.tweak)
      {:ok, deleted_star} = Accounts.unstar_tweak(context.user, context.tweak)
      stars = Accounts.list_stars(context.user)

      assert Enum.empty?(stars)
      assert deleted_star.user_id == context.user.id
      assert deleted_star.tweak_id == context.tweak.id
    end
  end

  describe "create_token/1" do
    test "succeeds when given valid token params", _context do
      params = params_for(:token)
      {:ok, token} = Accounts.create_token(params)

      assert token.description == params.description
      assert token.scopes == params.scopes
      assert token.user_id == params.user_id
    end

    test "fails when given a nil description", _context do
      params = params_for(:token, description: nil)
      {:error, changeset} = Accounts.create_token(params)

      assert "can't be blank" in errors_on(changeset, :description)
    end

    test "fails when given an empty description", _context do
      params = params_for(:token, description: "")
      {:error, changeset} = Accounts.create_token(params)

      assert "can't be blank" in errors_on(changeset, :description)
    end

    test "fails when given an empty scopes list", _context do
      params = params_for(:token, scopes: [])
      {:error, changeset} = Accounts.create_token(params)

      assert "should have at least 1 item(s)" in errors_on(changeset, :scopes)
    end

    test "fails when given an unrecognized scope", _context do
      params = params_for(:token, scopes: ["foo"])
      {:error, changeset} = Accounts.create_token(params)

      assert "has an invalid entry" in errors_on(changeset, :scopes)
    end
  end

  describe "delete_token/1" do
    test "succeeds when given a token that exists", _context do
      token = insert(:token)
      {:ok, returned} = Accounts.delete_token(token)

      assert token.description == returned.description
      assert token.scopes == returned.scopes
      assert token.user_id == returned.user_id
    end

    test "fails when given a token that does not exist", _context do
      user = insert(:user)
      token = build(:token, user_id: user.id)

      assert_raise Ecto.NoPrimaryKeyValueError, fn ->
        Accounts.delete_token(token)
      end
    end
  end

  describe "get_token/1" do
    test "succeeds when given a valid token code", _context do
      token = insert(:token)
      token_code = Token.to_code(token)
      {:ok, returned} = Accounts.get_token(token_code)

      assert returned.id == token.id
      assert returned.description == token.description
      assert returned.scopes == token.scopes
    end
  end

  describe "list_tokens/1" do
    test "returns the tokens for the user", _context do
      user = insert(:user)
      tokens = insert_list(3, :token, user: user)
      returned = Accounts.list_tokens(user)

      assert length(tokens) == length(returned)
      assert Enum.all?(tokens, fn token -> token in returned end)
    end
  end
end
