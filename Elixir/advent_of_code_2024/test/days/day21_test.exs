defmodule Day21Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 21}}
  end

  test "day 21 parsing works for sample input", context do
    input_string = ~s"029A
980A
179A
456A
379A"
    expected_input = [
      [0, 2, 9, :a],
      [9, 8, 0, :a],
      [1, 7, 9, :a],
      [4, 5, 6, :a],
      [3, 7, 9, :a]
    ]

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 21 part 1 works for sample input", context do
    input_string = ~s"029A
980A
179A
456A
379A"
    expected_result = "126384"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 21 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "42"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 2 works for sample input", context do
    input_string = ~s"029A
980A
179A
456A
379A"
    expected_result = "42"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 21 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "42"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
