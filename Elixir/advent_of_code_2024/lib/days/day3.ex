defmodule Days.Day3 do
  defstruct []

  defimpl DaySolver do
    @typep day_input() :: String.t()

    @spec parse_input(%Days.Day3{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text
    end



    @spec solve_part1(%Days.Day3{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      Regex.scan(~r"mul\((\d{1,3}),(\d{1,3})\)", input) |>
        Enum.map(fn match ->
          tl(match) |>
            Enum.map(&String.to_integer/1) |>
            Enum.product()
        end) |>
        Enum.sum() |>
        to_string()
    end

    @spec solve_part2(%Days.Day3{},day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      "42"
    end

  end
end
