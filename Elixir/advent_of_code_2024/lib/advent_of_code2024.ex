defmodule AdventOfCode2024 do
  @moduledoc """
  Documentation for `AdventOfCode2024`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AdventOfCode2024.hello()
      :world

  """
  def solve_problem(day, part) do
    input_text = InputReader.read_day_input(day)
    solver = day_solver(day)
    input = DaySolver.parse_input(solver, input_text)
    if part == 1 do
      DaySolver.solve_part1(solver, input)
    else
      DaySolver.solve_part2(solver, input)
    end
  end

  defp day_solver(day) do
    "Elixir.Day#{day}" |>
      String.to_existing_atom |>
      struct
  end
end
