defmodule AdventOfCode2024 do
  @moduledoc """
  Documentation for `AdventOfCode2024`.
  """

  @doc """
  Solve AdventOfCode 2024 problem.
  """
  @spec solve_problem(1..25, 1..2, boolean()) :: String.t() | {integer(), String.t()}
  def solve_problem(day, part, timed \\ false) do
    input_text = InputReader.read_day_input(day)
    solver = day_solver(day)
    input = DaySolver.parse_input(solver, input_text)
    if timed do
      :timer.tc(&solve_part/3, [solver, input, part])
    else
      solve_part(solver, input, part)
    end
  end

  @spec solve_problem(DaySolver.day_solver(), String.t(), 1..2) :: String.t()
  defp solve_part(solver, input, part) do
    if part == 1 do
      DaySolver.solve_part1(solver, input)
    else
      DaySolver.solve_part2(solver, input)
    end
  end

  @spec day_solver(1..25) :: DaySolver.day_solver()
  defp day_solver(day) do
    "Elixir.Days.Day#{day}" |>
      String.to_existing_atom |>
      struct
  end
end
