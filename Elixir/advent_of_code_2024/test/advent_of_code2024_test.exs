defmodule AdventOfCode2024Test do
  use ExUnit.Case
  doctest AdventOfCode2024

  test "solve_problem solves day 1 part 1" do
    actual_result = AdventOfCode2024.solve_problem(1, 1)
    expected_result = "2378066"
    assert actual_result == expected_result
  end

  test "solve_problem solves day 1 part 1 timed" do
    {_execution_time, actual_result} = AdventOfCode2024.solve_problem(1, 1, true)
    expected_result = "2378066"
    assert actual_result == expected_result
  end

  test "solve_problem solves day 1 part 2" do
    actual_result = AdventOfCode2024.solve_problem(1, 2)
    expected_result = "18934359"
    assert actual_result == expected_result
  end

  test "solve_problem solves day 1 part 2 timed" do
    {_execution_time, actual_result} = AdventOfCode2024.solve_problem(1, 2, true)
    expected_result = "18934359"
    assert actual_result == expected_result
  end
end
