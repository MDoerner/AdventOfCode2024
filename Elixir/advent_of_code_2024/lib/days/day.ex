defprotocol DaySolver do
  @typedoc """
  Input type specific to each day solver
  """
  @opaque day_solver_input() :: any() | any()
  @type day_solver() :: struct()

  @spec parse_input(day_solver(), String.t()) :: day_solver_input()
  def parse_input(day_solver, input_text)

  @spec solve_part1(day_solver(), day_solver_input()) :: String.t()
  def solve_part1(day_solver, input)

  @spec solve_part2(day_solver(), day_solver_input()) :: String.t()
  def solve_part2(day_solver, input)
end
