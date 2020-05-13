defmodule DarkHand.HTTP.Errors.HTTPResponseNotOKError do
  defexception message: "Response status code differs from 200 OK, something went wrong..."
end
