defmodule Padawan.Assertions.Be do
  use Padawan.Assertions.Interface

  defp match(subject, [op, val]) do
    result = apply(Kernel, op, [subject, val])
    {result, result}
  end

  defp success_message(subject, [op, val], result) do
    "`#{inspect(subject)} #{op} #{inspect(val)}` is #{result}."
  end

  defp error_message(subject, [op, val], result) do
    "Expected `#{inspect(subject)} #{op} #{inspect(val)}` to be `#{result}` but got `#{!result}`."
  end
end
