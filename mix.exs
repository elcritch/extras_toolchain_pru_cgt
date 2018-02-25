defmodule NervesPruIcss.MixProject do
  use Mix.Project

  @app :toolchain_extras_pru_cgt

  def project do
    [
      app: @app,
      name: "PruCGT",
      version: "0.3.0",
      elixir: "~> 1.4",
      nerves_package: nerves_package(),
      compilers: [:nerves_package | Mix.compilers()],
      description: "A wrapper for compiler TI's PRU C/C++ Compiler",
      deps: deps(),
      package: package(),
      aliases: [loadconfig: [&bootstrap/1]],
    ]
  end

  def nerves_package do
    [
      name: @app,
      type: :extras_toolchain,
      platform: Nerves.PruCGT.Toolchain,
      toolchain_extras: [
        env_var: "PRU_CGT",
        build_path_link: "ti-cgt-pru",
        build_script: "build.sh",
        clean_files: [ "ti-cgt-pru" ],
      ],
      platform_config: [
      ],
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
      # {:nerves, git: "https://github.com/elcritch/nerves.git", branch: "host_tools_fork", override: true },
      # {:nerves, git: "https://github.com/nerves-project/nerves.git", branch: "host_tools", override: true },
      {:nerves, "~> 1.0.0-rc", runtime: false},
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
      # "README.md",
      "LICENSE",
      # "mix.exs",
      # "lib",
    ]
  end


  defp bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end


end
