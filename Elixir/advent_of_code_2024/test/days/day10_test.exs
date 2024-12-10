defmodule Day10Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 10}}
  end

  test "day 10 parsing works for sample input", context do
    input_string = ~s"89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"
    expected_input = {
      {8, 8},
      {
        {8, 9, 0, 1, 0, 1, 2, 3},
        {7, 8, 1, 2, 1, 8, 7, 4},
        {8, 7, 4, 3, 0, 9, 6, 5},
        {9, 6, 5, 4, 9, 8, 7, 4},
        {4, 5, 6, 7, 8, 9, 0, 3},
        {3, 2, 0, 1, 9, 0, 1, 2},
        {0, 1, 3, 2, 9, 8, 0, 1},
        {1, 0, 4, 5, 6, 7, 3, 2}
      }
    }

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 10 part 1 works for sample input", context do
    input_string = ~s"89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"
    expected_result = "36"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 10 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "550"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 10 part 2 works for sample input", context do
    input_string = ~s"89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"
    expected_result = "81"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 10 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "1255"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
