defmodule DarkHand.HTTP.HTTPStream do
  def get(url) do
    Stream.resource(
      fn -> httpoison_get(url) end,
      fn resp -> httpoison_next_async(resp) end,
      fn resp -> :hackney.close(resp.id) end
    )
  end

  defp httpoison_get(url) do
    HTTPoison.get!(
      url, %{},
      stream_to: self(),
      async: :once
    )
  end

  defp httpoison_next_async(%HTTPoison.AsyncResponse{id: id} = resp) do
    receive do
      %HTTPoison.AsyncStatus{id: ^id, code: code} ->
        IO.inspect(code, label: "AsyncStatus, code = ")
        HTTPoison.stream_next(resp)
        {[], resp}
      %HTTPoison.AsyncHeaders{id: ^id, headers: headers} ->
        IO.inspect(headers, label: "AsyncHeaders, headers = ")
        HTTPoison.stream_next(resp)
        {[], resp}
      %HTTPoison.AsyncChunk{id: ^id, chunk: chunk} ->
        HTTPoison.stream_next(resp)
        {[chunk], resp}
      %HTTPoison.AsyncEnd{id: ^id} ->
        IO.puts "Request complete!"
        {:halt, resp}
    end
  end

end
