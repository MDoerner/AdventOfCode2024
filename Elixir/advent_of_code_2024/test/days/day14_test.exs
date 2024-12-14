defmodule Day14Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 14}}
  end

  test "day 14 parsing works for sample input", context do
    input_string = ~s"p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"
    expected_input = {
      {101, 103},
      [
        {{0, 4}, {3, -3}},
        {{6, 3}, {-1, -3}},
        {{10, 3}, {-1, 2}},
        {{2, 0}, {2, -1}},
        {{0, 0}, {1, 3}},
        {{3, 0}, {-2, -2}},
        {{7, 6}, {-1, -3}},
        {{3, 0}, {-1, -2}},
        {{9, 3}, {2, 3}},
        {{7, 3}, {-1, 2}},
        {{2, 4}, {2, -3}},
        {{9, 5}, {-3, -3}}
      ]
    }

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 14 part 1 works for sample input", context do
    input_string = ~s"p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3"
    expected_result = "12"

    solver = AdventOfCode2024.day_solver(context[:day])
    {_, robots} = DaySolver.parse_input(solver, input_string)
    input = {{11, 7}, robots}
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 14 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "226236192"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end


  @tag timeout: :infinity
  test "day 14 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "8168"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
