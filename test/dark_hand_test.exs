defmodule DarkHandTest do
  use ExUnit.Case
  doctest DarkHand

  test "greets the world" do
    assert DarkHand.hello() == :world
  end
end
