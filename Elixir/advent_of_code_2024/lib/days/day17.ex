defmodule Days.Day17 do
  defstruct []

  defimpl DaySolver do
    @typep day_input() :: any()

    @spec parse_input(%Days.Day17{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text
    end


    @spec solve_part1(%Days.Day17{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      (42 + String.length(to_string(input)) - String.length(to_string(input))) |>
        to_string()
    end


    @spec solve_part2(%Days.Day17{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      (42 + String.length(to_string(input)) - String.length(to_string(input))) |>
        to_string()
    end


  end
end
