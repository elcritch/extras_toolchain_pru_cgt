defmodule Mix.Tasks.Build.Env do
  use Mix.Task

  @shortdoc "Simply runs the Hello.say/0 command."
  def run(arg) do
    # calling our Hello.say() function from earlier
    IO.puts "build:env: #{inspect arg}"
    case arg do
      [dep] ->
        IO.puts Map.get(Mix.Project.deps_paths, dep)
      _ ->
        nil
    end
  end
end
