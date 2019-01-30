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

    quote do
      @tests {unquote(func), unquote(description)}
      def unquote(func)(), do: unquote(test_block)
    end
  end

  @doc "Aliases for `describe`."
  Enum.each(@aliases, fn func ->
    defmacro unquote(func)(description_or_opts, do: block) do
      quote do: describe(unquote(description_or_opts), do: unquote(block))
    end

    defmacro unquote(func)(do: block) do
      quote do: describe(do: unquote(block))
    end
  end)
end
