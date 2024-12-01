defmodule InputReader do
  @moduledoc """
  The `InputReader` provides the necessary utilities to read the input files for advent of code 2024.
  """

  @doc """
  Read Input for Day

  ## Examples

      iex> InputReader.read_day_input(1)

  """
  @spec read_day_input(integer()) :: String.t()
  def read_day_input(day) do
    filename = "#{File.cwd!}/../../Inputs/Day#{day}.txt"
    {:ok, contents} = File.read(filename)
    contents
  end
end
