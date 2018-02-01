defmodule Mix.Tasks.Build.Env do
  use Mix.Task

  @shortdoc "Simply runs the Hello.say/0 command."
  def run([dep]) do
    value = Map.get(Mix.Project.deps_paths, String.to_atom(dep)) || ''
    IO.puts "#{dep |> String.upcase}='#{value}'"
  end
  def run(_) do
  end
end
