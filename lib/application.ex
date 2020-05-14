defmodule DarkHand.Application do
  import DarkHand.Application.CLI

  def main(args) do
    args
    |> parse_command_line
    |> execute_command
  end
end
