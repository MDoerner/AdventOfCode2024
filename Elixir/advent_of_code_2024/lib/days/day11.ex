defmodule Days.Day11 do
  defstruct []

  defimpl DaySolver do
    @typep stone() :: non_neg_integer()
    @typep day_input() :: {list(stone()), non_neg_integer(), non_neg_integer()}

    @spec parse_input(%Days.Day11{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_line = hd(String.split(input_text, ~r"\r?\n"))
      stones = input_line |>
        String.split(~r"\s+") |>
        Enum.map(&String.to_integer/1)
      {stones, 25, 75}
    end


    @spec solve_part1(%Days.Day11{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {stones, times, _} = input
      stones |>
        blink(times) |>
        Enum.count() |>
        to_string()
    end

    @spec blink(list(stone), pos_integer()) :: list(stone())
    defp blink(stones, times) do\
      Range.new(1, times) |>
        Enum.reduce(stones, fn _, stones_before_next_blink ->
          blink_once(stones_before_next_blink)
        end)
    end

    @spec blink_once(list(stone)) :: list(stone())
    defp blink_once(stones) do\
      stones |>
        Enum.reduce([], fn stone, processed_stones ->
          blink_once_single_stone(stone) ++ processed_stones
        end) |>
        Enum.reverse()
    end

    @spec blink_once_single_stone(stone()) :: list(stone())
    defp blink_once_single_stone(stone) do\
      if stone == 0 do
        [1]
      else
        stone_text = to_string(stone)
        digits = String.length(stone_text)
        if rem(digits, 2) == 0 do
          stone_text |>
            String.split_at(floor(digits / 2)) |>
            Tuple.to_list() |>
            Enum.map(&String.to_integer/1) |>
            Enum.reverse()  # we assemble the stones in reverse
        else
          [stone * 2024]
        end
      end
    end



    @spec solve_part2(%Days.Day11{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {stones, _, times} = input
      stone_count_after_blinking(stones, times) |>
        to_string()
    end

    @spec stone_count_after_blinking(list(stone()), pos_integer()) :: non_neg_integer()
    defp stone_count_after_blinking(stones, times) do
      stone_counts = stones |>
        Enum.reduce(%{}, fn stone, known_stone_counts ->
          stone_counts_after_blinking(stone, times, known_stone_counts)
        end)
      stones |>
        Enum.map(fn stone -> stone_counts[{stone, times}] end) |>
        Enum.sum()
    end

    @spec stone_counts_after_blinking(stone(), non_neg_integer(), %{{stone(), non_neg_integer()} => pos_integer()}) :: %{{stone(), non_neg_integer()} => pos_integer()}
    defp stone_counts_after_blinking(stone, times, known_stone_counts) do
      if Map.has_key?(known_stone_counts, {stone, times}) do
        known_stone_counts
      else
        if times == 0 do
          Map.put(known_stone_counts, {stone, 0}, 1)
        else
          after_blink = blink_once_single_stone(stone)
          new_counts = after_blink |>
            Enum.reduce(known_stone_counts, fn new_stone, known_counts ->
              stone_counts_after_blinking(
                new_stone,
                times - 1,
                known_counts
              )
            end)
          stone_count = after_blink |>
            Enum.map(fn new_stone -> new_counts[{new_stone, times - 1}] end) |>
            Enum.sum()
          Map.put(new_counts, {stone, times}, stone_count)
        end
      end
    end

  end
end
