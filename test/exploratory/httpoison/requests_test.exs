defmodule DarkHand.Test.Exploratory.HTTPoison.Requests do
  use ExUnit.Case

  @tag :exploratory
  test "downloads a file with an HTTP GET request" do
    file_name = "image.png"
    %HTTPoison.Response{body: body} = HTTPoison.get!("https://upload.wikimedia.org/wikipedia/commons/d/d9/Test.png")
    File.write!(file_name, body)
    assert(File.exists?(file_name))

    %{size: size} = File.stat!(file_name)
    assert(size == 3118)

    File.rm!(file_name)
    assert(!File.exists?(file_name))
  end

  @tag :exploratory
  test "downloads a file and saves it with its original URL name" do
    the_url = "https://upload.wikimedia.org/wikipedia/commons/d/d9/Test.png"
    file_name = Path.basename(the_url)

    %HTTPoison.Response{body: body} = HTTPoison.get!(the_url)
    File.write!(file_name, body)
    assert(File.exists?(file_name))

    %{size: size} = File.stat!(file_name)
    assert(size == 3118)

    File.rm!(file_name)
    assert(!File.exists?(file_name))
  end
end
