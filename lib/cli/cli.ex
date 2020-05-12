defmodule DarkHand.Application.CLI do
  import DarkHand.HTTP.HTTPStream
  import DarkHand.HTTP.URL
  @module_doc """
    usage: ./dark_hand [--download|-d] <URL to download>
  """

  def parse_command_line(args) do
    cli_options = args |> OptionParser.parse!(
      strict: [help: :boolean, download: :boolean],
      aliases: [h: :help, d: :download]
    )

    case cli_options do
      {[help: true], _} -> :help
      {[download: true], [url]} -> {:download, url}
      _ -> :help
    end
  end

  def execute_command(:help) do
    IO.puts(@module_doc)
    System.halt(0)
  end
  def execute_command({:download, url}) do
    case url |> is_url_downloadable? do
      false ->
        IO.puts "[ERROR] Argument [#{url}] is not a URL or a downloadable resource. Refusing to download."
        System.halt(0)
      true ->
        url |> execute_download
    end
  end
end
