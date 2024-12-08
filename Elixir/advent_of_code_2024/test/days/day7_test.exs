defmodule Day7Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 7}}
  end

  test "day 7 parsing works for sample input", context do
    input_string = ~s"190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"
    expected_input = [
      {190, [10, 19]},
      {3267, [81, 40, 27]},
      {83, [17, 5]},
      {156, [15, 6]},
      {7290, [6, 8, 6, 15]},
      {161011, [16, 10, 13]},
      {192, [17, 8, 14]},
      {21037, [9, 7, 18, 13]},
      {292, [11, 6, 16, 20]}
    ]

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 7 part 1 works for sample input", context do
    input_string = ~s"190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"
    expected_result = "3749"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 7 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "66343330034722"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 7 part 2 works for sample input", context do
    input_string = ~s"190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20"
    expected_result = "11387"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 7 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "637696070419031"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
