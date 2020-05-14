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
    file_name = url |> Path.basename
    try do
      url
      |> get
      |> Stream.into(file_name |> File.stream!)
      |> Stream.run
    rescue
      e in HTTPoison.Error ->
        {e, file_name} |> handle_httpoison_error
      e in CaseClauseError ->
        {e, file_name} |> handle_case_clause_error
      e in DarkHand.HTTP.Errors.HTTPResponseNotOKError ->
        {e, file_name} |> handle_darkhand_error
    end
  end

  defp handle_httpoison_error({e, file_name}) do
    error = e |> Map.fetch(:reason) |> elem(1)
    case error do
      :nxdomain -> IO.puts "[ERROR] Domain does not exist."
      _ -> error |> IO.inspect([label: "[ERROR]"])
    end

    if file_name |> File.exists?, do: file_name |> File.rm!
  end

  defp handle_case_clause_error({e, file_name}) do
    e
    |> Map.fetch(:term)
    |> elem(1)
    |> IO.inspect([label: "[ERROR] no clause matching"])

    if file_name |> File.exists?, do: file_name |> File.rm!
  end

  defp handle_darkhand_error({e, file_name}) do
    e
    |> Map.fetch(:message)
    |> elem(1)
    |> (&("[ERROR] " <> &1)).()
    |> IO.puts

    if file_name |> File.exists?, do: file_name |> File.rm!
  end
end
