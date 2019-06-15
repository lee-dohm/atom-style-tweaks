defmodule AtomTweaks.Accounts.TokenTest do
  use AtomTweaks.DataCase

  alias AtomTweaks.Accounts.Token

  describe "to_code/1" do
    test "succeeds when given a valid token", _context do
      token = insert(:token)

      assert is_binary(Token.to_code(token))
    end
  end
end
