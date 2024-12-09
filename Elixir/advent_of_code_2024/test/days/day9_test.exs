defmodule Day9Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 9}}
  end

  test "day 9 parsing works for sample input", context do
    input_string = ~s"2333133121414131402"
    expected_input = {
      Enum.reverse([{0, {0, 2}}, {1, {5, 3}}, {2, {11, 1}}, {3, {15, 3}}, {4, {19, 2}}, {5, {22, 4}}, {6, {27, 4}}, {7, {32, 3}}, {8, {36, 4}}, {9, {40, 2}}]),
      [{2, 3}, {8, 3}, {12, 3}, {18, 1}, {21, 1}, {26, 1}, {31, 1}, {35, 1}, {40, 0}]
    }

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 9 part 1 works for sample input", context do
    input_string = ~s"2333133121414131402"
    expected_result = "1928"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 9 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "6332189866718"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 9 part 2 works for sample input", context do
    input_string = ~s"2333133121414131402"
    expected_result = "2858"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 9 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "6353648390778"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
