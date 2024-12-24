defmodule Day23Test do
  use ExUnit.Case

  setup_all do
    {:ok, %{day: 23}}
  end

  test "day 23 parsing works for sample input", context do
    input_string = ~s"kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn"
    expected_input = [
      {"kh", "tc"},
      {"qp", "kh"},
      {"de", "cg"},
      {"ka", "co"},
      {"yn", "aq"},
      {"qp", "ub"},
      {"cg", "tb"},
      {"vc", "aq"},
      {"tb", "ka"},
      {"wh", "tc"},
      {"yn", "cg"},
      {"kh", "ub"},
      {"ta", "co"},
      {"de", "co"},
      {"tc", "td"},
      {"tb", "wq"},
      {"wh", "td"},
      {"ta", "ka"},
      {"td", "qp"},
      {"aq", "cg"},
      {"wq", "ub"},
      {"ub", "vc"},
      {"de", "ta"},
      {"wq", "aq"},
      {"wq", "vc"},
      {"wh", "yn"},
      {"ka", "de"},
      {"kh", "ta"},
      {"co", "tc"},
      {"wh", "qp"},
      {"tb", "vc"},
      {"td", "yn"},
    ]

    solver = AdventOfCode2024.day_solver(context[:day])
    {execution_time, actual_input} = :timer.tc(&DaySolver.parse_input/2, [solver, input_string])
    IO.inspect(execution_time, label: "day #{context[:day]} example parsing execution time in microseconds")
    assert actual_input == expected_input
  end

  test "day 23 part 1 works for sample input", context do
    input_string = ~s"kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn"
    expected_result = "7"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 example execution time in microseconds")
    assert actual_result == expected_result
  end

  @tag timeout: :infinity
  test "day 23 part 1 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "1238"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part1/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 1 real execution time in microseconds")
    assert actual_result == expected_result
  end

  test "day 23 part 2 works for sample input", context do
    input_string = ~s"kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn"
    expected_result = "co,de,ka,ta"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 example execution time in microseconds")
    assert actual_result == expected_result
  end

  # Takes too long to stay in the general test suite.

  @tag timeout: :infinity
  test "day 23 part 2 works for real input", context do
    input_string = InputReader.read_day_input(context[:day])
    expected_result = "bg,bl,ch,fn,fv,gd,jn,kk,lk,pv,rr,tb,vw"

    solver = AdventOfCode2024.day_solver(context[:day])
    input = DaySolver.parse_input(solver, input_string)
    {execution_time, actual_result} = :timer.tc(&DaySolver.solve_part2/2, [solver, input])
    IO.inspect(execution_time, label: "day #{context[:day]} part 2 real execution time in microseconds")
    assert actual_result == expected_result
  end
end
