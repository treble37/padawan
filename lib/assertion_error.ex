defmodule Padawan.AssertionError do
  @moduledoc """
  Defines Padawan.AssertionError exception.
  The exception is raised by `Padawan.Assertions.Interface.raise_error/3` when example fails.
  """
  defexception subject: nil,
               data: nil,
               result: nil,
               assertion: nil,
               message: nil,
               extra: nil
end
