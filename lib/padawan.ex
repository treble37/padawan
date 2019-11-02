defmodule Padawan do
  @moduledoc """
  The Padawanmodule. Imports a lot of Padawan components.
  Defines macros 'context', 'describe'.
  One should `use` the module in spec modules.
  """

  @aliases ~w(context)a

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      # Elixir allows us to set a special module attribute, @before_compile, to notify the compiler that an extra step is required just before compilation is finished.
      Module.register_attribute(__MODULE__, :tests, accumulate: true)
      import Padawan.ExpectTo
      import Padawan.Expect
      import Padawan.Helpers
      import Padawan.Assertions.Be
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run_tests, do: Padawan.TestRunner.run(@tests, __MODULE__)
    end
  end

  @doc "describe with description only"
  defmacro describe(_description, do: block) do
    quote do: unquote(block)
  end

  @doc "describe with no description"
  defmacro describe(do: block) do
    quote do: describe("", do: unquote(block))
  end

  defmacro it(description, do: test_block) do
    func = String.to_atom(description)

    quote bind_quoted: [description: description, test_block: test_block] do
      @tests {__ENV__.line, func, description}
      def unquote(func)(), do: unquote(test_block)
    end
  end

  @doc "Aliases for `describe`."
  Enum.each(@aliases, fn func ->
    defmacro unquote(func)(description, do: block) do
      quote bind_quoted: [description: description, block: block],
            do: describe(description, do: block)
    end

    defmacro unquote(func)(do: block) do
      quote bind_quoted: [block: block], do: describe(do: block)
    end
  end)
end
