defmodule HaveInSessionAssertion do
  use ESpec.Assertions.Interface

  import Plug.Conn, only: [get_session: 2]

  defp match(conn, [key, value]) do
    result = get_session(conn, key)

    cond do
      result == nil -> {false, [key, nil]}
      result == value -> {true, [key, value]}
      true -> {false, [key, result]}
    end
  end

  defp match(conn, key) do
    result = get_session(conn, key)

    {result, result}
  end

  defp success_message(_conn, [key, value], _result, positive) do
    to = if positive, do: "has", else: "does not have"

    "Connection #{to} `#{key}` set to `#{value}` in its session"
  end

  defp success_message(_conn, key, _result, positive) do
    to = if positive, do: "has", else: "does not have"

    "Connection #{to} `#{key}` in its session"
  end

  defp error_message(_conn, [key, value], [_key, nil], positive) do
    to = if positive, do: "have", else: "not have"

    "Expected connection to #{to} `#{key}` set to `#{value}` in its session, but `#{key}` did not exist"
  end

  defp error_message(_conn, [key, value], [_key, result], positive) do
    to = if positive, do: "have", else: "not have"

    "Expected connection to #{to} `#{key}` set to `#{value}` in its session, but `#{key}` was set to `#{result}` instead"
  end

  defp error_message(_conn, key, _result, positive) do
    to = if positive, do: "have", else: "not have"

    "Expected connection to #{to} `#{key}` in its session"
  end
end
