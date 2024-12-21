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

  test "day 21 part 1 works for sample input part 1", context do
    input_string = ~s"029A"
    expected_result = 68 * 29 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time part 1 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 1 works for sample input part 2", context do
    input_string = ~s"980A"
    expected_result = 60 * 980 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time part 2 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 1 works for sample input part 3", context do
    input_string = ~s"179A"
    expected_result = 68 * 179 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time part 3 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 1 works for sample input part 4", context do
    input_string = ~s"456A"
    expected_result = 64 * 456 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time part 4 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 1 works for sample input part 5", context do
    input_string = ~s"379A"
    expected_result = 64 * 379 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time part 5 in microseconds")
    assert actual_result == expected_result
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
    expected_result = "171596"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end






  test "day 21 part 1 works for sample input part 1 ref", context do
    input_string = ~s"029A"
    expected_result = 68 * 29 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time part 1 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 2 works for sample input part 1", context do
    input_string = ~s"029A"
    expected_result = 82050061710 * 29 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time part 1 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 2 works for sample input part 2", context do
    input_string = ~s"980A"
    expected_result = 72242026390 * 980 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time part 2 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 2 works for sample input part 3", context do
    input_string = ~s"179A"
    expected_result = 81251039228 * 179 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time part 3 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 2 works for sample input part 4", context do
    input_string = ~s"456A"
    expected_result = 80786362258 * 456 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time part 4 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 2 works for sample input part 5", context do
    input_string = ~s"379A"
    expected_result = 77985628636 * 379 |> to_string

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time part 5 in microseconds")
    assert actual_result == expected_result
  end

  test "day 21 part 2 works for sample input", context do
    input_string = ~s"029A
980A
179A
456A
379A"
    expected_result = "154115708116294"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 21 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "209268004868246"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
