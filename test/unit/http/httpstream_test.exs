defmodule DarkHand.Test.Unit.HTTP.HTTPStream do
  use ExUnit.Case
  doctest DarkHand.HTTP.HTTPStream

  describe "Testing downloading files" do
    setup do
      [url: "http://speedtest.tele2.net/100MB.zip"]
    end

    @tag timeout: :infinity
    @tag :unit
    test "downloads files from URLs", context do
      file_name = Path.basename(context[:url])
      on_exit(fn -> cleanup(file_name) end)

      context[:url]
      |> DarkHand.HTTP.HTTPStream.get
      |> Stream.into(File.stream!(file_name))
      |> Stream.run

      %{size: size} = File.stat!(file_name)
      assert(File.exists?(file_name))
      assert(size == 104857600)
    end

    def cleanup(file_name) do
      File.rm!(file_name)
      assert(!File.exists?(file_name))
    end

  end


end
