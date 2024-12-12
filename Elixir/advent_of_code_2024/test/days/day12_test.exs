defmodule Day12Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 12}}
  end

  test "day 12 parsing works for sample input", context do
    input_string = ~s"RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"
    expected_input =
      {
        {10, 10},
        {
          {"R", "R", "R", "R", "I", "I", "C", "C", "F", "F"},
          {"R", "R", "R", "R", "I", "I", "C", "C", "C", "F"},
          {"V", "V", "R", "R", "R", "C", "C", "F", "F", "F"},
          {"V", "V", "R", "C", "C", "C", "J", "F", "F", "F"},
          {"V", "V", "V", "V", "C", "J", "J", "C", "F", "E"},
          {"V", "V", "I", "V", "C", "C", "J", "J", "E", "E"},
          {"V", "V", "I", "I", "I", "C", "J", "J", "E", "E"},
          {"M", "I", "I", "I", "I", "I", "J", "J", "E", "E"},
          {"M", "I", "I", "I", "S", "I", "J", "E", "E", "E"},
          {"M", "M", "M", "I", "S", "S", "J", "E", "E", "E"}
        }
      }

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 12 part 1 works for sample input 1", context do
    input_string = ~s"AAAA
BBCD
BBCC
EEEC"
    expected_result = "140"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 12 part 1 works for sample input 2", context do
    input_string = ~s"OOOOO
OXOXO
OOOOO
OXOXO
OOOOO"
    expected_result = "772"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 12 part 1 works for sample input 3", context do
    input_string = ~s"RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"
    expected_result = "1930"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 12 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "1381056"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 12 part 2 works for sample input 1", context do
    input_string = ~s"AAAA
BBCD
BBCC
EEEC"
    expected_result = "80"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 12 part 2 works for sample input 2", context do
    input_string = ~s"OOOOO
OXOXO
OOOOO
OXOXO
OOOOO"
    expected_result = "436"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 12 part 2 works for sample input 3", context do
    input_string = ~s"RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"
    expected_result = "1206"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 12 part 2 works for sample input 4", context do
    input_string = ~s"EEEEE
EXXXX
EEEEE
EXXXX
EEEEE"
    expected_result = "236"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 12 part 2 works for sample input 5", context do
    input_string = ~s"AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA"
    expected_result = "368"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 12 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "834828"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
