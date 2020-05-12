defmodule DarkHand.HTTP.URL do
  def is_url_valid?(url) do
    case URI.parse(url) do
      %URI{scheme: nil} -> false
      %URI{host: nil} -> false
      %URI{path: nil} -> false
      _ -> true
    end
  end

  def is_url_a_resource?(url) do
    retval = url |> String.to_charlist |> :inet.gethostbyname
    case retval do
      {:error, :nxdomain} -> false
      _ -> true
    end
  end

  def is_url_downloadable?(url) do
    is_url_valid?(url) # and is_url_a_resource?(url)
  end
end
