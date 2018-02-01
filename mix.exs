defmodule NervesPruIcss.MixProject do
  use Mix.Project

  @app :extras_toolchain_pru_cgt

  def project do
    [
      app: @app,
      name: "PruCGT",
      version: "0.1.0",
      elixir: "~> 1.6",
      nerves_package: nerves_package(),
      compilers: [:nerves_package | Mix.compilers()],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "A wrapper for compiler TI's PRU C/C++ Compiler",
      deps: deps(),
      package: package(),
      aliases: ["deps.precompile": ["nerves.env", "deps.precompile"]]
    ]
  end

  def nerves_package do
    [
      name: @app,
      type: :extras,
      platform: Nerves.Toolchain.Extra,
      platform_config: [
      ],
      target_tuple: :arm_unknown_linux_gnueabihf,
      artifact_sites: [
        {:github_releases, "elcritch/extras_toolchain_pru_cgt"}
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
      links: %{"Github" => "https://github.com/elcritch/#{@app}"},
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
