defmodule DarkHand.HTTP.URL do
  def is_url_valid?(url) do
    case get_parsed(url) do
      %{scheme: nil} -> false
      %{host: nil} -> false
      _ -> true
    end
  end

  def is_url_toplevel?(url) do
    case get_parsed(url) do
      %{path: nil} ->
        IO.puts "[ERROR] You're trying to download a top level domain."
        true
      %{path: "/"} ->
        IO.puts "[ERROR] You're trying to download a top level domain."
        true
      _ -> false
    end
  end

  def is_url_downloadable?(url) do
    is_url_valid?(url) and not is_url_toplevel?(url)
  end

  def get_parsed(url) do
    parsed = url |> URI.parse
    %{
      scheme: parsed |> Map.fetch!(:scheme),
      host: parsed |> Map.fetch!(:host),
      path: parsed |> Map.fetch!(:path)
    }
  end
end
