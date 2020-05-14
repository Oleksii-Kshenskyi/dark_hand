defmodule DarkHand.Test.Exploratory.Basic.StringsTest do
  use ExUnit.Case

  @tag :exploratory
  test "retrieves last element name in URL" do
    the_url = "https://upload.wikimedia.org/wikipedia/commons/d/d9/Test.png"
    assert(Path.basename(the_url) == "Test.png")
  end

end
