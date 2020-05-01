defmodule DarkHand.Test.Unit.Application do
  use ExUnit.Case
  doctest DarkHand.Application

  @tag :unit
  test "converts two nums to integers and adds them" do
    assert DarkHand.Application.dummy_add_two_nums("120", "131") == 251
    assert DarkHand.Application.dummy_add_two_nums("0", "-2") == -2
  end

  @tag :unit
  test "fails when arguments are integers and not strings" do
    assert_raise ArgumentError, fn ->
      DarkHand.Application.dummy_add_two_nums(1, 1)
    end
  end
end
