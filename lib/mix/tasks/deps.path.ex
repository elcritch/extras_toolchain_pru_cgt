defmodule Mix.Tasks.Nerves.Path.Dep do
  use Mix.Task

  @shortdoc "Print the path for a given dependency "
  def run([dep]) do
    value = Map.get(Mix.Project.deps_paths, String.to_atom(dep)) || ''
    IO.puts "#{value}"
  end
  def run(_) do
  end
end

# defmodule Mix.Tasks.Nerves.Path.Artifact do
defmodule Mix.Tasks.Deps.Path do
  use Mix.Task

  @shortdoc "Print the path for a given nerves artifact "
  def run([dep]) do

    Nerves.Env.start
    Nerves.Env.ensure_loaded(Mix.Project.config[:app])

    dep_paths = Nerves.Env.packages() |> Enum.map(fn d -> {d.app, d} end) |> Map.new

    case Map.get(dep_paths, String.to_atom(dep)) do
      nil ->
        IO.puts ""
      nerves_package ->
        # IO.puts "#{inspect nerves_package}"
        IO.puts "#{Nerves.Artifact.dir nerves_package}"
    end

  end

  def run(_) do
  end
end
