defmodule Padawan do
  @moduledoc """
  The Padawanmodule. Imports a lot of Padawan components.
  Defines macros 'context', 'describe'.
  One should `use` the module in spec modules.
  """

  @spec_agent :padawan_spec_agent

  @aliases ~w(context)a

  defmacro __using__(_opts) do
    quote do
      Padawan.add_spec(__MODULE__)
      import unquote(__MODULE__)

      # Elixir allows us to set a special module attribute, @before_compile, to notify the compiler that an extra step is required just before compilation is finished.
      Module.register_attribute(__MODULE__, :specs, accumulate: true)
      import Padawan.ExpectTo
      import Padawan.Expect
      import Padawan.Helpers
      import Padawan.Assertions.Be
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run_tests, do: Padawan.TestRunner.run(@specs, __MODULE__)
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
    quote bind_quoted: [
            func: function_id(description),
            test_block: test_block
          ] do
      @specs {__ENV__.line, func}
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

  @doc "Start agent to store module specs"
  def start do
    start_spec_agent()
  end

  @doc "Adds example to the agent."
  def add_spec(module), do: Agent.update(@spec_agent, &[module | &1])

  @doc "Returns all modules with specs"
  def specs, do: Agent.get(@spec_agent, & &1)

  defp start_spec_agent, do: Agent.start_link(fn -> [] end, name: @spec_agent)

  defp function_id(description) do
    UUID.uuid1()
    |> ShortUUID.encode!()
    |> Kernel.<>("--")
    |> Kernel.<>(description)
    |> String.to_atom()
  end
end
