defmodule Days.Day4 do
  defstruct []

  defimpl DaySolver do
    @typep day_input() :: %{{non_neg_integer(), non_neg_integer()} => String.t()}

    @spec parse_input(%Days.Day4{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      parse(input_text, "XMAS")
    end

    @spec parse(String.t(), String.t()) :: day_input()
    defp parse(input_text, sought) do
      relevant_letters = MapSet.new(String.graphemes(sought))
      input_text |>
      String.split(~r"\r?\n") |>
      Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
      Enum.with_index() |>
      Enum.reduce(%{}, fn {line, y}, letters ->
        line |>
          String.graphemes() |>
          Enum.with_index() |>
          Enum.reduce(letters, fn {letter, x}, letters ->
            if MapSet.member?(relevant_letters, letter) do
              Map.put(letters, {y, x}, letter)
            else
              letters
            end
          end)
      end)
    end



    @spec solve_part1(%Days.Day4{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      Map.keys(input) |>
        Enum.map(fn point -> matches_at(point, input, "XMAS") end) |>
        Enum.sum() |>
        to_string()
    end

    @spec matches_at({non_neg_integer(), non_neg_integer()}, day_input(), String.t()) :: non_neg_integer()
    defp matches_at(point, letters, sought) do
      if letters[point] == String.first(sought) do
        directions = [{0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}, {-1, 1}]
        Enum.count(directions, fn direction -> match_in_direction?(point, direction, letters, sought) end)
      else
        0
      end
    end

    @spec match_in_direction?({non_neg_integer(), non_neg_integer()}, {non_neg_integer(), non_neg_integer()}, day_input(), String.t()) :: boolean()
    defp match_in_direction?({y, x}, {y_dir, x_dir}, letters, sought) do
      sought |>
      String.graphemes() |>
      Enum.with_index() |>
      Enum.all?(fn {letter, offset} ->
        letter == letters[{y + offset * y_dir, x + offset * x_dir}]
      end)
    end



    @spec solve_part2(%Days.Day4{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      Map.keys(input) |>
        Enum.count(fn point -> x_mas_at?(point, input) end) |>
        to_string()
    end

    @spec x_mas_at?({non_neg_integer(), non_neg_integer()}, day_input()) :: boolean()
    defp x_mas_at?({y, x}, letters) do
      letters[{y, x}] == "A"
      and ((letters[{y-1, x-1}] == "M" and letters[{y+1, x+1}] == "S")
        or (letters[{y-1, x-1}] == "S" and letters[{y+1, x+1}] == "M"))
      and ((letters[{y-1, x+1}] == "M" and letters[{y+1, x-1}] == "S")
        or (letters[{y-1, x+1}] == "S" and letters[{y+1, x-1}] == "M"))
    end

  end
end
