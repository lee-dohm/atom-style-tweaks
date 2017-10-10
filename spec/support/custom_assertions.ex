defmodule CustomAssertions do
  def have_in_session(key), do: {HaveInSessionAssertion, key}
  def have_in_session(key, value), do: {HaveInSessionAssertion, [key, value]}
end
