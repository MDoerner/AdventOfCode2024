defmodule Day17Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 17}}
  end

  test "day 17 parsing works for sample input", context do
    input_string = ~s"Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0"
    expected_input = {
      {729, 0, 0},
      {0, 1, 5, 4, 3, 0}
    }

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 17 part 1 works for small sample input 1", context do
    input_string = ~s"Register A: 0
Register B: 0
Register C: 9

Program: 2,6"
    expected_result = ""

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 17 part 1 works for small sample input 2", context do
    input_string = ~s"Register A: 10
Register B: 0
Register C: 0

Program: 5,0,5,1,5,4"
    expected_result = "0,1,2"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 17 part 1 works for small sample input 3", context do
    input_string = ~s"Register A: 2024
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0"
    expected_result = "4,2,5,6,7,7,7,7,3,1,0"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 17 part 1 works for small sample input 4", context do
    input_string = ~s"Register A: 0
Register B: 29
Register C: 0

Program: 1,7"
    expected_result = ""

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 17 part 1 works for small sample input 5", context do
    input_string = ~s"Register A: 0
Register B: 2024
Register C: 43690

Program: 4,0"
    expected_result = ""

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 17 part 1 works for sample input", context do
    input_string = ~s"Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0"
    expected_result = "4,6,3,5,6,3,5,2,1,0"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 17 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "3,4,3,1,7,6,5,6,0"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 17 part 2 works for sample input", context do
    input_string = ~s"Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0"
    expected_result = "117440"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 17 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "109019930331546"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
