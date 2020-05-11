defmodule DarkHand.Test.Exploratory.Basic.ListsMapsAtoms do
  use ExUnit.Case

  @tag :exploratory
  test "list of tuples with atom and value and list of semicolon pairs are the same thing" do
    assert([a: "a"] == [{:a, "a"}])
    # assert([{a: "a"}] != [{:a, "a"}]) # [{a: "a"}] is a compilation error
  end

  @tag :exploratory
  test "taking map out of atom-value pair list" do
    list_of_maps = [
                      one: %{name: "one", number: 1, comment: "no comment"},
                      two: %{name: "two", number: 2, comment: "no comment two"},
                      three: %{name: "three", number: 3, comment: "no comment three"}
                   ]

    assert(Map.keys(list_of_maps[:one]) == [:comment, :name, :number])
    assert(Map.values(list_of_maps[:two]) == ["no comment two", "two", 2])
    # assert(Map.keys(list_of_maps) == [:one, :three, :two]) # list of pairs is not a map
  end

end
