defmodule Padawan.ExpectTo do
  @moduledoc """
    Defines `to` function(s) which call specific 'assertion'
  """

  @doc "Calls specific assertion."
  def to({__MODULE__, subject}, {module, data}) do
    apply(module, :assert, [subject, data])
  end
end
