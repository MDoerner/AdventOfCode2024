defmodule Day18Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 18}}
  end

  test "day 18 parsing works for sample input", context do
    input_string = ~s"5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0"
    expected_input = {
      {0, 0},
      {70, 70},
      {71, 71},
      [{5,4}, {4,2}, {4,5}, {3,0}, {2,1}, {6,3}, {2,4}, {1,5}, {0,6}, {3,3}, {2,6}, {5,1}, {1,2}, {5,5}, {2,5}, {6,5}, {1,4}, {0,4}, {6,4}, {1,1}, {6,1}, {1,0}, {0,5}, {1,6}, {2,0}],
      1024
    }

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 18 part 1 works for sample input", context do
    input_string = ~s"5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0"
    expected_result = "22"

    solver = AdventOfCode2024.day_solver(context[:day])
    {_, _, _, blocks, _} = DaySolver.parse_input(solver, input_string)
    input = {{0, 0}, {6, 6}, {7, 7}, blocks, 12}
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 18 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "306"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 18 part 2 works for sample input", context do
    input_string = ~s"5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0"
    expected_result = "6,1"

    solver = AdventOfCode2024.day_solver(context[:day])
    {_, _, _, blocks, _} = DaySolver.parse_input(solver, input_string)
    input = {{0, 0}, {6, 6}, {7, 7}, blocks, 12}
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 18 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "38,63"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
