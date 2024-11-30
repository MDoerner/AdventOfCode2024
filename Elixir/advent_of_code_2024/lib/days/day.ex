defprotocol DaySolver do
  def parse_input(day_solver, input_text)
  def solve_part1(day_solver, input)
  def solve_part2(day_solver, input)
end
