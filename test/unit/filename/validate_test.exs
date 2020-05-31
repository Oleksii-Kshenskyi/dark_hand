defmodule DarkHand.Test.Unit.File.Name.Validate do
  use ExUnit.Case
  doctest DarkHand.File.Name.Validate
  import DarkHand.File.Name.Validate

  @tag :unit
  @tag :unitfast
  test "checks for file name correctness" do
    assert is_char_valid?("_") == true
    assert is_char_valid?("2") == true
    assert is_char_valid?("k") == true
    assert is_char_valid?("K") == true
    assert is_char_valid?(".") == true
    assert is_char_valid?("-") == true

    assert is_char_valid?(" ") == false
    assert is_char_valid?("[") == false
    assert is_char_valid?("{") == false
    assert is_char_valid?("/") == false
    assert is_char_valid?("*") == false
    assert is_char_valid?("?") == false
    assert is_char_valid?("!") == false
    assert is_char_valid?("|") == false
    assert is_char_valid?(">") == false
    assert is_char_valid?("<") == false
    assert is_char_valid?("@") == false
    assert is_char_valid?("#") == false
  end

  @tag :unit
  @tag :unitfast
  test "corrects invalid file names" do
    assert correct_filename("a-correct_filename-3") == "a-correct_filename-3"
    assert correct_filename("a-correct_filename-3.jpg") == "a-correct_filename-3.jpg"
    assert correct_filename("a-cor@ect_fil?na=e-3.jpg") == "a-cor_ect_fil_na_e-3.jpg"
    assert correct_filename("!@#$%^&*(){}[]  ") == "________________"
    assert correct_filename("...jpg") == "...jpg"
  end
end
