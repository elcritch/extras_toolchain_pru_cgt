defmodule NervesPruIcss.MixProject do
  use Mix.Project

  @app :toolchain_extras_pru_cgt

  def project do
    [
      app: @app,
      name: "PruCGT",
      version: "3.0.1",
      elixir: "~> 1.4",
      compilers: [:nerves_package] ++ Mix.compilers(),
      nerves_package: nerves_package(),
      description: "A wrapper for compiler TI's PRU C/C++ Compiler",
      deps: deps(),
      package: package(),
      # aliases: ["deps.precompile": ["nerves.env", "deps.precompile"], loadconfig: [&bootstrap/1]]
      aliases: [loadconfig: [&bootstrap/1]],
    ]
  end

  def nerves_package do
    [
      name: @app,
      type: :extras_toolchain,
      platform: NervesExtras.Toolchain,
      toolchain_extras: [
        env_var: "PRU_CGT",
        build_path_link: "ti-cgt-pru",
        build_script: "build.sh",
        clean_files: ["ti-cgt-pru"],
        archive_script: "scripts/archive.sh"
      ],
      platform_config: [],
      target_tuple: :arm_unknown_linux_gnueabihf,
      artifact_sites: [
        {:github_releases, "elcritch/#{@app}"}
      ],
      checksum: package_files()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:nerves, "~> 1.0", runtime: false},
      {:toolchain_extras, "~> 0.2", runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Jaremy Creechley"],
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/elcritch/#{@app}"}
    ]
  end

  defp package_files do
    [
      "README.md",
      "LICENSE",
      "mix.exs",
      "lib",
      "config"
    ]
  end

  defp bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end
end
