defmodule Day20Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 20}}
  end

  test "day 20 part 1 works for sample input", context do
    input_string = ~s"###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############"
    expected_result = "8"

    solver = AdventOfCode2024.day_solver(context[:day])
    {start_point, end_point, track, dimensions, _goal} = DaySolver.parse_input(solver, input_string)
    input = {start_point, end_point, track, dimensions, 12}
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 20 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "1286"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: 600
  test "day 20 part 2 works for sample input", context do
    input_string = ~s"###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############"
    expected_result = (3+4+22+12+14+12+19+20+23+25+39+29+31+32) |> to_string()

    solver = AdventOfCode2024.day_solver(context[:day])
    {start_point, end_point, track, dimensions, _goal} = DaySolver.parse_input(solver, input_string)
    input = {start_point, end_point, track, dimensions, 50}
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 20 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "989316"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
