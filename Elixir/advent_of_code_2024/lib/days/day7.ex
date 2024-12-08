defmodule Days.Day7 do
  defstruct []

  defimpl DaySolver do
    @typep reference_value() :: pos_integer()
    @typep test_values() :: list(pos_integer())
    @typep calibration() :: {reference_value(), test_values()}
    @typep day_input() :: list(calibration())
    @typep operator() :: String.t()

    @spec parse_input(%Days.Day7{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text |>
        String.split(~r"\r?\n") |>
        Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(&parse_calibration/1)
    end

    @spec parse_calibration(String.t()) :: calibration()
    defp parse_calibration(text) do
      [referece_value_text, test_text] = String.split(text, ~r":\s*")
      test_values = test_text |>
        String.split(~r"\s+") |>
        Enum.map(&String.to_integer/1)
      {String.to_integer(referece_value_text), test_values}
    end


    @spec solve_part1(%Days.Day7{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      input |>
      Enum.filter(fn calibration -> valid_calibration?(calibration, ["+", "*"]) end) |>
      Enum.map(fn {value, _} -> value end) |>
      Enum.sum() |>
      to_string()
    end

    @spec valid_calibration?(calibration(), list(operator())) :: boolean()
    defp valid_calibration?({reference_value, test_values}, operators) do
      [start | tail] = test_values
      possible = tail |>
        Enum.reduce(MapSet.new([start]), fn next_value, possible_so_far ->
          possible_values(next_value, possible_so_far, reference_value, operators)
        end)
      MapSet.member?(possible, reference_value)
    end

    @spec possible_values(pos_integer(), MapSet.t(pos_integer()), pos_integer(), list(operator())) :: MapSet.t(pos_integer())
    defp possible_values(next_value, possible_before, refernce_value, operators) do
      operators |>
        Enum.map(fn operator -> possible_values_for_operator(next_value, possible_before, refernce_value, operator) end) |>
        Enum.reduce(&MapSet.union/2)
    end

    @spec possible_values_for_operator(pos_integer(), MapSet.t(pos_integer()), pos_integer(), operator()) :: MapSet.t(pos_integer())
    defp possible_values_for_operator(next_value, possible_before, refernce_value, operator) do
      possible_before |>
        Stream.map(fn value -> apply_operator(value, next_value, operator) end) |>
        Stream.reject(fn value -> value > refernce_value end) |>
        MapSet.new()
    end


    defp apply_operator(value, other_value, operator) do
      case operator do
        "+" -> value + other_value
        "*" -> value * other_value
        "||" -> String.to_integer(to_string(value) <> to_string(other_value))
      end
    end




    @spec solve_part2(%Days.Day7{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      input |>
        Enum.filter(fn calibration -> valid_calibration?(calibration, ["+", "*", "||"]) end) |>
        Enum.map(fn {value, _} -> value end) |>
        Enum.sum() |>
        to_string()
    end

  end
end
