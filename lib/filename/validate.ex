defmodule DarkHand.File.Name.Validate do
  def is_char_valid?(char) do
    char |> String.at(0) |> String.match?(~r/^[\w.-]$/)
  end

  def correct_filename(file_name) do
    file_name
    |> String.to_charlist
    |> Enum.map(
      fn(element) ->
        case is_char_valid?(<<element>>) do
          true -> <<element>>
          false -> "_"
        end
      end
    )
    |> List.to_string
  end
end
