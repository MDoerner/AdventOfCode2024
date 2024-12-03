defmodule Days.Day2 do
  defstruct []

  defimpl DaySolver do
    @typep day_input() :: list(list(integer()))

    @spec parse_input(%Days.Day2{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text |>
      String.split(~r"\r?\n") |>
      Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
      Enum.map(fn line -> line |>
                                  String.split(~r"\s+") |>
                                  Enum.map(fn number_text -> String.to_integer(number_text) end)
               end)
    end



    @spec solve_part1(%Days.Day2{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      input |>
        Enum.count(&safe_sequence?/1) |>
        to_string()
    end

    @spec safe_sequence?(list(integer())) :: boolean()
    defp safe_sequence?(sequence)

    defp safe_sequence?([]) do
      true
    end

    defp safe_sequence?([_single_value]) do
      true
    end

    defp safe_sequence?(sequence) do
      [first | tail] = sequence
      second = hd(tail) # Will not fail because of other variants of the function's definition.
      if first == second do
        false
      else
        direction = trunc((second - first)/abs(second - first))
        safe_sequence_in_direction?(first, tail, direction)
      end
    end

    # Assumes that the tail is not empty, which is true where it is used.
    @spec safe_sequence_in_direction?(integer(), list(integer()), -1 | 1) :: boolean()
    defp safe_sequence_in_direction?(first, tail, direction) do
      initial_state = {true, first}
      {safe, _} = Enum.reduce_while(
        tail,
        initial_state,
        fn next_value, {_, previous_value} ->
          if safe_next_value?(next_value, direction, previous_value) do
            {:cont, {true, next_value}}
          else
            {:halt, {false, next_value}}
          end
        end
      )
      safe
    end



    @spec safe_next_value?(integer(), 1 | -1, integer()) :: boolean()
    defp safe_next_value?(next_value, direction, previous_value) do
      step_in_direction = (next_value - previous_value) * direction
      step_in_direction >= 1 and step_in_direction <= 3
    end



    @spec solve_part2(%Days.Day2{},day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      input |>
        Enum.count(&safe_sequence_with_dampener?/1) |>
        to_string()
    end

    @spec safe_sequence_with_dampener?(list(integer())) :: boolean()
    defp safe_sequence_with_dampener?(sequence)

    defp safe_sequence_with_dampener?([]) do
      true
    end

    defp safe_sequence_with_dampener?([_single_value]) do
      true
    end

    defp safe_sequence_with_dampener?([_single_value, _second_value]) do
      true
    end

    defp safe_sequence_with_dampener?(sequence) do
      [first | tail] = sequence
      [second | remainder] = tail # Will not fail because of other variants of the function's definition.
      cond do
        first == second -> safe_sequence?(tail) #we have to remove first or second and which does not matter
        safe_sequence?(tail) -> true #safe without first
        safe_sequence?([first] ++ remainder) -> true #safe without second
        not (safe_next_value?(second, 1, first) or safe_next_value?(second, -1, first)) -> false #the first two are required if we reach this
        true -> safe_sequence_with_dampener_first_two_valid_and_required?(first, second, remainder)
      end
    end

    @spec safe_sequence_with_dampener_first_two_valid_and_required?(integer(), integer(),list(integer())) :: boolean()
    defp safe_sequence_with_dampener_first_two_valid_and_required?(first, second, remaining_sequence) do
      direction = trunc((second - first)/abs(second - first))
      initial_state = {true, first, second, remaining_sequence}
      {safe, _, _, _} = Enum.reduce_while(
        remaining_sequence,
        initial_state,
        fn next_value, {_, value_two_back, previous_value, remaining} ->
          new_remaining = tl(remaining)
          if safe_next_value?(next_value, direction, previous_value) do
            {:cont, {true, previous_value, next_value, new_remaining}}
          else
            if Enum.empty?(new_remaining) do
              {:halt, {true, value_two_back, previous_value, new_remaining}}
            else
              is_safe = (safe_next_value?(next_value, direction, value_two_back)
                  and safe_sequence_in_direction?(next_value, new_remaining, direction))
                or safe_sequence_in_direction?(previous_value, new_remaining, direction)
              {:halt, {is_safe, previous_value, next_value, new_remaining}}
            end
          end
        end
      )
      safe
    end
  end
end
