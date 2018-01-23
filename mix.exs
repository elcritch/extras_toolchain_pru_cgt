defmodule NervesPruIcss.MixProject do
  use Mix.Project

  def project do
    [
      app: :nerves_pru_icss,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "A wrapper for compiler TI's PRU C/C++ Compiler",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:shell_template, "~> 0.1.0", github: "elcritch/shell_template"}
      # {:dep_from_hexpm, "~> 0.3.0"},
    ]
  end
end
