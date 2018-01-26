defmodule NervesPruIcss.MixProject do
  use Mix.Project

  def project do
    [
      app: :nerves_pru_icss,
      version: "0.1.0",
      elixir: "~> 1.6",
      nerves_package: nerves_package(),
      compilers: [:nerves_package | Mix.compilers()],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "A wrapper for compiler TI's PRU C/C++ Compiler",
      deps: deps(),
      aliases: ["deps.precompile": ["nerves.env", "deps.precompile"]]
    ]
  end

  def nerves_package do
    [
      name: "nerves_pru_icss",
      type: :extras,
      platform: Nerves.Toolchain.CTNG,
      platform_config: [
      ],
      target_tuple: :arm_unknown_linux_gnueabihf,
      artifact_sites: [
        {:github_releases, "elcritch/nerves_pru_icss"}
      ],
      checksum: package_files()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:nerves, "~> 0.9", runtime: false},
    ]
  end


  defp package do
    [
      maintainers: ["Jaremy Creechley"],
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{
        "Github" =>
        "https://github.com/elcritch/nerves_pru_icss/#{@app}"
      }
    ]
  end

  defp package_files do
    [
      "README.md",
      "LICENSE",
      "mix.exs",
      "VERSION"
    ]
  end

end
