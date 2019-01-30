defmodule Padawan.TestRunner do
  def run(tests, module) do
    Enum.each(tests, fn {line_num, test_function, description} ->
      case apply(module, test_function, []) do
        {:ok, _msg} ->
          IO.write("Line #{line_num}, #{description} passing...")
      end
    end)
  end
end
