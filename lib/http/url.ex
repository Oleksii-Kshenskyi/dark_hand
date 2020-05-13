defmodule DarkHand.HTTP.URL do
  def is_url_valid?(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> false
      %URI{host: nil} -> false
      _ -> true
    end
  end

  def is_url_toplevel?(url) do
    case URI.parse(url) do
      %URI{path: nil} ->
        IO.puts "[ERROR] You're trying to download a top level domain."
        true
      %URI{path: "/"} ->
        IO.puts "[ERROR] You're trying to download a top level domain."
        true
      _ -> false
    end
  end

  def is_url_downloadable?(url) do
    is_url_valid?(url) and not is_url_toplevel?(url)
  end
end

