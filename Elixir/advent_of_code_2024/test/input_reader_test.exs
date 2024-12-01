defmodule InputReaderTest do
  use ExUnit.Case
  doctest InputReader

  test "reads test input file" do
    assert InputReader.read_day_input("_Test") == "eee\r\nss\r\nee\r\nr\r\n\r\ne\r\nwwww"
  end
end
