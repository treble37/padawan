defmodule Padawan.Assertions.Interface do
  @moduledoc """
  Defines the assertion interface.
  There are 3 functions that should be defined in the 'assertion' module:
  - `match/2`;
  - `success_message/3`;
  - `error_message/3`.
  """
  defmacro __using__(_opts) do
    quote do
      def assert(subject, data) do
        case match(subject, data) do
          {false, result} -> raise_error(subject, data, result)
          {true, result} -> {:ok, success_message(subject, data, result)}
        end
      end

      defp raise_error(subject, data, result) do
        e = error_message(subject, data, result)

        {message, extra} =
          case e do
            {_, _} -> e
            _ -> {e, nil}
          end

        raise Padawan.AssertionError,
          subject: subject,
          data: data,
          result: result,
          assertion: __MODULE__,
          message: message,
          extra: extra
      end
    end
  end
end
