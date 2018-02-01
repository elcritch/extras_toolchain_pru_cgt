defmodule Mix.Tasks.Deps.Get do
  use Mix.Task

  @shortdoc "Simply runs the Hello.say/0 command."
  def run(_) do
    # calling our Hello.say() function from earlier
    IO.puts "Hello!"
  end
end
