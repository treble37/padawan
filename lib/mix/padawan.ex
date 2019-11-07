defmodule Mix.Tasks.Padawan do
  use Mix.Task

  def run(_args) do
    Mix.shell().print_app

    Padawan.start()

    Code.require_file("spec/assertions/be_spec.exs")

    Padawan.specs()
    |> Enum.each(&apply(&1, :run_tests, []))
  end
end
