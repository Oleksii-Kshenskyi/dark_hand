defmodule DarkHand.Test.Exploratory.HTTPoison.Requests do
  use ExUnit.Case

  @tag :exploratory
  test "downloads a file with an HTTP GET request" do
    %HTTPoison.Response{body: body} = HTTPoison.get!("https://upload.wikimedia.org/wikipedia/commons/d/d9/Test.png")
    File.write!("image.png", body)
    assert(File.exists?("image.png"))

    %{size: size} = File.stat!("image.png")
    assert(size == 3118)

    File.rm!("image.png")
    assert(!File.exists?("image.png"))
  end
end
