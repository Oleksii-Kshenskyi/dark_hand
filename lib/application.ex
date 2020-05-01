defmodule DarkHand.Application do
  def dummy_add_two_nums(first_string,second_string) do
    String.to_integer(first_string) + String.to_integer(second_string)
  end
  def main([first_string, second_string]) do
    IO.puts "The sum is: #{ dummy_add_two_nums(first_string, second_string) }!"
  end
end
