defmodule Padawan.Expect do
  @moduledoc """
  Defines `expect` helper functions.
  These functions wrap arguments for Padawan.ExpectTo module.
  """

  alias Padawan.ExpectTo

  @doc "Wrapper for `Padawan.ExpectTo`."
  def expect(value), do: {ExpectTo, value}
end
