defmodule Days.Day5 do
  defstruct []

  defimpl DaySolver do
    @typep day_input() :: {%{non_neg_integer() => MapSet.t(non_neg_integer())}, list(list(non_neg_integer()))}

    @spec parse_input(%Days.Day5{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      [rules_text, manuals_text] = String.split(input_text, ~r"\r?\n\r?\n")
      {parse_rules(rules_text), parse_manuals(manuals_text)}
    end

    @spec parse_rules(String.t()) :: %{non_neg_integer() => MapSet.t(non_neg_integer())}
    defp parse_rules(rules_text) do
      rules_text |>
        String.split(~r"\r?\n") |>
        Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.reduce(%{}, fn rule, rules ->
          [before, later] = rule |>
            String.split("|") |>
            Enum.map(&String.to_integer/1)
          Map.update(rules, before, MapSet.new([later]), fn old_laters -> MapSet.put(old_laters, later) end)
        end)
    end

    @spec parse_manuals(String.t()) :: list(list(non_neg_integer()))
    defp parse_manuals(manuals_text) do
      manuals_text |>
        String.split(~r"\r?\n") |>
        Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
        Enum.map(fn line ->
          line |>
            String.split(~r",\s*") |>
            Enum.map(&String.to_integer/1)
        end)
    end


    @spec solve_part1(%Days.Day4{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {rules, manuals} = input
      manuals |>
        Enum.filter(fn manual -> ordered?(manual, rules) end) |>
        Enum.map(&middle_page/1) |>
        Enum.sum() |>
        to_string()
    end

    @spec ordered?(list(non_neg_integer()), %{non_neg_integer() => MapSet.t(non_neg_integer())}) :: boolean()
    defp ordered?(manual, rules) do
      initial_state = {true, MapSet.new()}
      {ordered, _} = Enum.reduce_while(manual, initial_state, fn page, {ordered, visited_pages} ->
        later_pages = Map.get(rules, page, MapSet.new())
        still_ordered = ordered and not Enum.any?(later_pages, fn later_page -> MapSet.member?(visited_pages, later_page) end)
        if still_ordered do
          {:cont, {true, MapSet.put(visited_pages, page)}}
        else
          {:halt, {false, visited_pages}}
        end
      end)
      ordered
    end

    @spec middle_page(list(non_neg_integer())) :: non_neg_integer()
    defp middle_page(manual) do
      fixed_manual = List.to_tuple(manual)
      middle_index = floor(tuple_size(fixed_manual)/2)
      elem(fixed_manual, middle_index)
    end



    @spec solve_part2(%Days.Day5{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {rules, manuals} = input
      manuals |>
        Enum.reject(fn manual -> ordered?(manual, rules) end) |>
        Enum.map(fn manual ->
          Enum.sort(manual, fn page, other_page ->
            not MapSet.member?(Map.get(rules, other_page, MapSet.new()), page)
          end)
        end) |>
        Enum.map(&middle_page/1) |>
        Enum.sum() |>
        to_string()
    end

  end
end
