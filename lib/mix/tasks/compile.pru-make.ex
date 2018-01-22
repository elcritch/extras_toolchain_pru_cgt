defmodule Mix.Tasks.Compile.PruMake do
  use Mix.Task

  @recursive true

  @moduledoc """
  Compiles PRU firmware code in the current project.

  """

  @unix_error_msg """
    * Buildroot (Linux): You need to have ti-cgt-pru compiler installed in addition to make installed.
      If you are using Ubuntu or any other Debian-based system, install the packages
      "build-essential" for gnu make tools. The TI PRU-ICSS tools can be downloaded from TI, or in the
      case of Buildroot, select the "ti-cgt-pru" package for the host tools.
  """

  @spec run(OptionParser.argv()) :: :ok | no_return
  def run(args) do
    config = Mix.Project.config() |> Keyword.get(:nerves_pru, [])
    Mix.shell().print_app()
    build(config, args)
    Mix.Project.build_structure()
    :ok
  end

  # This is called by Elixir when `mix clean` is run and `:elixir_make` is in
  # the list of compilers.
  def clean() do
    config = Mix.Project.config() |> Keyword.get(:nerves_pru, [])
    #{clean_targets, config} = Keyword.pop(config, :pru_clean)

    #if clean_targets do
    #  config
    #  |> Keyword.put(:pru_targets, clean_targets)
    #  |> build([])
    #end
  end

  @pru_compiler_args %{
    linker_command_file: "./#{args.src}/AM335x_PRU.cmd",
    libs: ~w{--library=#{args.ssp}/lib/rpmsg_lib.lib},
    include: ~w{--include_path=#{args.ssp}/include --include_path=#{args.ssp}/include/am335x --include_path=../../../firmware/include"},

    #Common compiler and linker flags (Defined in 'PRU Optimizing C/C++ Compiler User's Guide)
    cflags: ~w{-v3 -O2 --display_error_number --endian=little --hardware_mac=on -ppd -ppa},  # --obj_directory=$(GEN_DIR) --pp_directory=$(GEN_DIR)

    #Linker flags (Defined in 'PRU Optimizing C/C++ Compiler User's Guide)
    lflags: ~w{--reread_libs --warn_sections --stack_size=0x100 --heap_size=0x100},
  }

  # Returns a list of command-line args to pass to make (or nmake/gmake) in
  # order to specify the makefile to use.
  defp compiler_args(:pru_cc, args) do
    args = Map.merge args, @pru_compiler_args

    ~w"""
      $(PRU_CGT)/bin/clpru --include_path=$(PRU_CGT)/include $(INCLUDE) $(CFLAGS) -fe $@ $<
      """
  end
  defp compiler_args(:pru_linker, args) do
    args = Map.merge args, @pru_compiler_args

    ~w"""
      #{args.cgt}/bin/clpru #{args.cflags} -z -i#{args.cgt}/lib -i#{args.cgt}/include #{args.lflags} -o $(TARGET) $(OBJECTS) -m#{args.map} #{args.linker_command_file} --library=#{args.cgt}/lib/libc.a #{args.libs}
      """
  end
  defp compiler_args(:gnu_cross, _) do
    %{}
  end

  defp build(config, task_args) do

    # hardcode nerves requirement (for now at least)
    toolchain =
      Keyword.get(config, :toolchain_path) ||
        System.get_env("NERVES_TOOLCHAIN") ||
          Mix.raise "Could not find Nerves Toolchain Path in system environment.\n"

    pru_cgt = Keyword.get(config, :pru_cgt_path) || "#{toolchain}/share/ti-cgt-pru/")
    pru_ssp = Keyword.get(config, :pru_ssp_path) || "#{toolchain}/../build/host-pru-software-support-v5.1.0/")

    env =
      Keyword.get(config, :pru_env, %{})
      |> Map.put_new("PATH", "#{pru_cgt}/bin:$PATH")

    pru_cc =
      System.get_env("PRU_CC") ||
        Keyword.get(config, :pru_cc, "clpru")

    cwd = Keyword.get(config, :pru_cwd, ".") |> Path.expand(File.cwd!())

    compiler_config = %{cc: pru_cc, cgt: pru_cgt, ssp: pru_ssp, env: env, toolchain: toolchain}
    args = compiler_args(:pru_cc, compiler_config)

    targets = Keyword.get(config, :pru_targets, [])

    IO.puts("make pru_cc: #{inspect(pru_cc)}")
    IO.puts("make cwd: #{inspect(cwd)}")
    IO.puts("make args: #{inspect(args)}")

    # for i <- :os.cmd('env') |> to_string() |> String.split("\n"),
    #     do: IO.puts("make env: #{inspect(i)}")

    for target <- targets do
      run_cmd(pru_cc, args, cwd, env, "--verbose" in task_args)
    end

    :ok
  end

  # Runs `exec [args]` in `cwd` and prints the stdout and stderr in real time,
  # as soon as `exec` prints them (using `IO.Stream`).
  defp run_cmd(exec, args, target, cwd, env, verbose?) do
    opts = [
      into: IO.stream(:stdio, :line),
      stderr_to_stdout: true,
      cd: cwd,
      env: env
    ]

    if verbose? do
      print_verbose_info(exec, args)
    end

    {%IO.Stream{}, status} = System.cmd(find_executable(exec), args, opts)

    case status do
      0 ->
        :ok

      exit_status ->
        raise_build_error(exec, exit_status, "error compiling: #{inspect target}")
    end
  end

  defp find_executable(exec) do
    System.find_executable(exec) ||
      Mix.raise("""
      "#{exec}" not found in the path. If you have set the MAKE environment variable,
      please make sure it is correct.
      """)
  end

  defp raise_build_error(exec, exit_status, error_msg) do
    Mix.raise "Could not compile with `#{exec}`` (exit status: #{exit_status}).\n" <> error_msg
  end

  # defp executable(exec) when is_binary(exec), do: exec
  #
  # defp executable(:application), do: @cross_compiler
  #
  # defp executable(:firmware), do: @ti_cgt_pru

  defp print_verbose_info(exec, args) do
    args =
      Enum.map_join(args, " ", fn arg ->
        if String.contains?(arg, " "), do: inspect(arg), else: arg
      end)

    Mix.shell().info("Compiling with make: #{exec} #{args}")
  end
end
