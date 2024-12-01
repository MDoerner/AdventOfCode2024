defmodule Day1Test do
  use ExUnit.Case

  test "day 1 parsing works for sample input" do
    input_string = ~s"3   4
4   3
2   5
1   3
3   9
3   3"
    solver = %Days.Day1{}
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    expected_input = {[3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]}
    IO.inspect(execution_time, label: "day 1 example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 1 part 1 works for sample input" do
    input_string = ~s"3   4
4   3
2   5
1   3
3   9
3   3"
    solver = %Days.Day1{}
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day 1 part 1 example execution time in microseconds")
    expected_result = 11
    assert actual_result == expected_result
  end

  test "day 1 part 1 works for real input" do
    input_string = InputReader.read_day_input(1)
    solver = %Days.Day1{}
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day 1 part 1 real execution time in microseconds")
    expected_result = 2378066
    assert actual_result == expected_result
  end

  test "day 1 part 2 works for sample input" do
    input_string = ~s"3   4
4   3
2   5
1   3
3   9
3   3"
    solver = %Days.Day1{}
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day 1 part 2 example execution time in microseconds")
    expected_result = 31
    assert actual_result == expected_result
  end

  test "day 1 part 2 works for real input" do
    input_string = InputReader.read_day_input(1)
    solver = %Days.Day1{}
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day 1 part 2 real execution time in microseconds")
    expected_result = 18934359
    assert actual_result == expected_result
  end
end
