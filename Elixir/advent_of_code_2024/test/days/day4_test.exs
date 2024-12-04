defmodule Day4Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 4}}
  end

  test "day 4 parsing works for sample input", context do
    input_string = ~s"....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
.X.X.XMASX"
    expected_input = %{
      {0, 4} => "X", {0, 5} => "X", {0, 6} => "M", {0, 7} => "A", {0, 8} => "S",
      {1, 1} => "S", {1, 2} => "A", {1, 3} => "M", {1, 4} => "X", {1, 5} => "M", {1, 6} => "S",
      {2, 3} => "S", {2, 6} => "A",
      {3, 2} => "A", {3, 4} => "A", {3, 6} => "M", {3, 7} => "S", {3, 9} => "X",
      {4, 0} => "X", {4, 1} => "M", {4, 2} => "A", {4, 3} => "S", {4, 4} => "A", {4, 5} => "M", {4, 6} => "X", {4, 8} => "M", {4, 9} => "M",
      {5, 0} => "X", {5, 6} => "X", {5, 7} => "A", {5, 9} => "A",
      {6, 0} => "S", {6, 2} => "S", {6, 4} => "S", {6, 6} => "S", {6, 8} => "S", {6, 9} => "S",
      {7, 1} => "A", {7, 3} => "A", {7, 5} => "A", {7, 7} => "A", {7, 9} => "A",
      {8, 2} => "M", {8, 4} => "M", {8, 6} => "M", {8, 8} => "M", {8, 9} => "M",
      {9, 1} => "X", {9, 3} => "X", {9, 5} => "X", {9, 6} => "M", {9, 7} => "A", {9, 8} => "S", {9, 9} => "X"
    }

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 4 part 1 works for sample input", context do
    input_string = ~s"MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"
    expected_result = "18"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 4 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "2493"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 4 part 2 works for sample input", context do
    input_string = ~s"MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"
    expected_result = "9"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 4 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "1890"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
