
defmodule Nerves.System.ToolchainExtras do
  use Nerves.Package.Platform

  alias Nerves.Artifact
  import Mix.Nerves.Utils

  # @callback bootstrap(Nerves.Package.t()) :: :ok | {:error, error :: term}
  def bootstrap(pkg) do

    System.put_env("NERVES_PRU", "ECHO")
    IO.puts "ECHO!!!!"

    :ok
  end

  # @callback build_path_link(package :: Nerves.Package.t()) :: build_path_link :: String.t()

  @doc """
  Return the location in the build path to where the global artifact is linked
  """
  def build_path_link(pkg) do
    IO.puts "extras:build_path_link: pkg: #{inspect pkg}"

    path_link = pkg.config[:build_path_link] || ""
    build_path = Artifact.build_path(pkg) || ""

    path = Path.join(build_path, path_link)
    IO.inspect path, label: :extras_build_path_link
  end

end
