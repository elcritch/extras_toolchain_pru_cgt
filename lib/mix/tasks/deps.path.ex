defmodule Mix.Tasks.Nerves.Path.Dep do
  use Mix.Task

  @shortdoc "Print the path for a given dependency "
  def run([dep]) do
    value = Map.get(Mix.Project.deps_paths, String.to_atom(dep)) || ''
    IO.puts "#{dep |> String.upcase}=\"#{value}\""
  end
  def run(_) do
  end
end

defmodule Mix.Tasks.Nerves.Path.Artifact do
  use Mix.Task

  @shortdoc "Print the path for a given nerves artifact "
  def run([dep]) do
    dep_paths = Nerves.Env.packages() |> Enum.map(fn d -> {d.app, d.path} end) |> Map.new
    value = Map.get(dep_paths, String.to_atom(dep)) || ''
    IO.puts "#{dep |> String.upcase}=\"#{value}\""
  end
  def run(_) do
  end
end
