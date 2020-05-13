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
      async: :once,
      follow_redirect: true
    )
  end

  defp httpoison_next_async(%HTTPoison.AsyncResponse{id: id} = resp) do
    receive do
      %HTTPoison.AsyncStatus{id: ^id, code: code} ->
        IO.inspect(code, label: "AsyncStatus, code = ")
        case code do
          200 ->
            HTTPoison.stream_next(resp)
            {[], resp}
          _ ->
            raise DarkHand.HTTP.Errors.HTTPResponseNotOKError
        end
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
      %HTTPoison.AsyncRedirect{to: to} = resp ->
        IO.puts("[REDIRECTED] Following redirect to #{to}...")
        execute_download(to)
        {:halt, resp}
    end
  end

  def execute_download(url) do
    try do
      url
      |> get
      |> Stream.into(url |> Path.basename |> File.stream!)
      |> Stream.run
    rescue
      e in HTTPoison.Error ->
        e |> handle_httpoison_error
      e in CaseClauseError ->
        e |> handle_case_clause_error
      e in DarkHand.HTTP.Errors.HTTPResponseNotOKError ->
        e |> handle_darkhand_error
    end
  end

  defp handle_httpoison_error(e) do
    error = e |> Map.fetch(:reason) |> elem(1)
    case error do
      :nxdomain -> IO.puts "[ERROR] Domain does not exist."
      _ -> error |> IO.inspect([label: "[ERROR]"])
    end
  end

  defp handle_case_clause_error(e) do
    e
    |> Map.fetch(:term)
    |> elem(1)
    |> IO.inspect([label: "[ERROR] no clause matching"])
  end

  defp handle_darkhand_error(e) do
    e
    |> Map.fetch(:message)
    |> elem(1)
    |> (&("[ERROR] " <> &1)).()
    |> IO.puts
  end
end
