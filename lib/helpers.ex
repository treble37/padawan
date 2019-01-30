defmodule Padawan.Helpers do
  @moduledoc """
  Defines helper functions for modules which use Padawan.
  These functions wrap arguments for Padawan.ExpectTo module.
  See `Padawan.Assertion` module for corresponding 'assertion modules'
  """

  alias Padawan.Assertions

  def be(operator, value), do: {Assertions.Be, [operator, value]}
end
