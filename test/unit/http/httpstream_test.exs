defmodule DarkHand.Test.Unit.HTTP.HTTPStream do
  use ExUnit.Case
  doctest DarkHand.HTTP.HTTPStream

  describe "Testing downloading files" do
    setup do
      %{
        100 => %{
                  url: "http://speedtest.tele2.net/100MB.zip",
                  expected_size: 104857600,
                  expected_file_name: "100MB.zip"
                },
          1 => %{
                  url: "http://speedtest.tele2.net/1MB.zip",
                  expected_size: 1048576,
                  expected_file_name: "1MB.zip"
                },
       2.02 => %{
                  url: "https://upload.wikimedia.org/wikipedia/commons/4/4e/Pleiades_large.jpg",
                  expected_size: 2119781,
                  expected_file_name: "Pleiades_large.jpg"
                },
      0.003 => %{
                  url: "https://upload.wikimedia.org/wikipedia/commons/d/d9/Test.png",
                  expected_size: 3118,
                  expected_file_name: "Test.png"
                }
      }
    end

    defp generic_download_and_asserts(download_size, context) do
      file_name = Path.basename(context[download_size][:url])
      on_exit(fn -> cleanup(file_name) end)

      context[download_size][:url]
      |> DarkHand.HTTP.HTTPStream.get
      |> Stream.into(File.stream!(file_name))
      |> Stream.run

      %{size: size} = File.stat!(file_name)
      assert(File.exists?(file_name))
      assert(file_name == context[download_size][:expected_file_name])
      assert(size == context[download_size][:expected_size])
    end

    @tag timeout: :infinity
    @tag :unit
    @tag :unitslow
    test "downloads a 100MB file", context do
      generic_download_and_asserts(100, context)
    end

    @tag timeout: :infinity
    @tag :unit
    @tag :unitfast
    test "downloads a 1MB file", context do
      generic_download_and_asserts(1, context)
    end

    @tag timeout: :infinity
    @tag :unit
    @tag :unitfast
    test "downloads a 2.02MB file", context do
      generic_download_and_asserts(2.02, context)
    end

    @tag :unit
    @tag :unitfast
    test "downloads a 3KB file", context do
      generic_download_and_asserts(0.003, context)
    end

    def cleanup(file_name) do
      File.rm!(file_name)
      assert(!File.exists?(file_name))
    end

  end


end
