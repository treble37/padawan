defmodule Padawan.TestRunner do
  def run(tests, module) do
    Enum.each(tests, fn {line_num, test_function} ->
      case apply(module, test_function, []) do
        {:ok, success_msg} ->
          IO.write("Line #{line_num}, #{test_function}: #{success_msg}")
      end
    end)
  end
end
