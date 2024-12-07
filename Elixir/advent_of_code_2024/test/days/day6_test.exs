defmodule Day6Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 6}}
  end

  test "day 6 parsing works for sample input", context do
    input_string = ~s"....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
    expected_input = {
      {10, 10},
      MapSet.new([{0, 4}, {1, 9}, {3, 2}, {4, 7}, {6, 1}, {7, 8}, {8, 0}, {9, 6}]),
      {6, 4}
    }

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 6 part 1 works for sample input", context do
    input_string = ~s"....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
    expected_result = "41"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 6 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "5453"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 6 part 2 works for sample input", context do
    input_string = ~s"....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
    expected_result = "6"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 6 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "2188"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
