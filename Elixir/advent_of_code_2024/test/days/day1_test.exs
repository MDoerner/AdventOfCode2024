defmodule Day1Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 1}}
  end

  test "day 1 parsing works for sample input", context do
    input_string = ~s"3   4
4   3
2   5
1   3
3   9
3   3"
    expected_input = {[3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]}

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 1 part 1 works for sample input", context do
    input_string = ~s"3   4
4   3
2   5
1   3
3   9
3   3"
    expected_result = "11"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 1 part 1 works for real input", context do
    input_string = InputReader.read_day_input(1)
    expected_result = "2378066"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 1 part 2 works for sample input", context do
    input_string = ~s"3   4
4   3
2   5
1   3
3   9
3   3"
    expected_result = "31"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 1 part 2 works for real input", context do
    input_string = InputReader.read_day_input(1)
    expected_result = "18934359"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
