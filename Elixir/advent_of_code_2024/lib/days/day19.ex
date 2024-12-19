defmodule Days.Day19 do
  defstruct []

  defimpl DaySolver do
    @typep towel() :: String.t()
    @typep color_scheme() :: String.t()
    @typep day_input() :: {list(towel()), list(color_scheme())}

    @spec parse_input(%Days.Day19{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      [towels_text, schemes_text] = input_text |> String.split(~r"\r?\n\r?\n")
      {
        parse_towels(towels_text),
        parse_color_schemes(schemes_text)
      }
    end

    @spec parse_towels(String.t()) :: list(towel())
    defp parse_towels(text) do
      text |> String.split(~r"\s*,\s*")
    end

    @spec parse_color_schemes(String.t()) :: list(color_scheme())
    defp parse_color_schemes(text) do
      text |>
        String.split(~r"\r?\n") |>
        Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end)
    end

    @spec solve_part1(%Days.Day19{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {towels, color_schemes} = input
      possible_starts = possible_start_towels(color_schemes, towels)
      color_schemes |>
        Enum.count(fn scheme -> Map.has_key?(possible_starts, scheme) end) |>
        to_string()
    end

    @spec possible_start_towels(list(color_scheme()), list(towel())) :: %{color_scheme() => MapSet.t(towel())}
    defp possible_start_towels(color_schemes, towels) do
      color_schemes |>
        Enum.reduce(%{}, fn color_schemes, known_starts ->
          possible_start_towels_impl(color_schemes, towels, known_starts)
        end)
    end


    @spec possible_start_towels_impl(color_scheme(), list(towel()), %{color_scheme() => MapSet.t(towel())}) :: %{color_scheme() => MapSet.t(towel())}
    defp possible_start_towels_impl(color_scheme, towels, known_possible_starts) do
      if String.length(color_scheme) == 0 or Map.has_key?(known_possible_starts, color_scheme) do
        known_possible_starts
      else
        towels |>
          Enum.reduce(known_possible_starts, fn towel, known_starts ->
            if color_scheme == towel do
              Map.update(
                known_starts,
                color_scheme,
                MapSet.new([towel]),
                fn starts -> MapSet.put(starts, towel) end
              )
            else
              if String.starts_with?(color_scheme, towel) do
                suffix = String.replace_prefix(color_scheme, towel, "")
                known_suffix_starts = possible_start_towels_impl(suffix, towels, known_starts)
                if Map.has_key?(known_suffix_starts, suffix) do
                  Map.update(
                    known_suffix_starts,
                    color_scheme,
                    MapSet.new([towel]),
                    fn starts -> MapSet.put(starts, towel) end
                  )
                else
                  known_suffix_starts
                end
              else
                known_starts
              end
            end
          end)
      end
    end


    @spec solve_part2(%Days.Day19{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {towels, color_schemes} = input
      possible_starts = possible_start_towels(color_schemes, towels)
      arrangement_counts = number_of_arrangements(color_schemes, possible_starts)
      color_schemes |>
        Enum.map(fn scheme -> Map.get(arrangement_counts, scheme, 0) end) |>
        Enum.sum() |>
        to_string()
    end

    @spec number_of_arrangements(list(color_scheme()), %{color_scheme() => MapSet.t(towel())}) :: %{color_scheme() => non_neg_integer()}
    defp number_of_arrangements(color_schemes, possible_start_towels) do
      color_schemes |>
        Enum.reduce(%{}, fn color_schemes, known_counts ->
          number_of_arrangements_impl(color_schemes, possible_start_towels, known_counts)
        end)
    end

    @spec number_of_arrangements_impl(color_scheme(), %{color_scheme() => MapSet.t(towel())}, %{color_scheme() => non_neg_integer()}) :: %{color_scheme() => non_neg_integer()}
    defp number_of_arrangements_impl(color_scheme, possible_start_towels, known_arrangement_counts) do
      cond do
        Map.has_key?(known_arrangement_counts, color_scheme) -> known_arrangement_counts
        String.length(color_scheme) == 0 -> Map.put(known_arrangement_counts, color_scheme, 1)
        not Map.has_key?(possible_start_towels, color_scheme) -> Map.put(known_arrangement_counts, color_scheme, 0)
        true ->
          start_towels = possible_start_towels[color_scheme]
          start_towels |>
            Enum.reduce(known_arrangement_counts, fn towel, known_counts ->
              if towel == color_scheme do
                Map.update(
                  known_counts,
                  color_scheme,
                  1,
                  fn count -> count + 1 end
                )
              else
                suffix = String.replace_prefix(color_scheme, towel, "")
                suffix_counts = number_of_arrangements_impl(suffix, possible_start_towels, known_counts)
                if Map.has_key?(suffix_counts, suffix) do
                  count = suffix_counts[suffix]
                  Map.update(
                    suffix_counts,
                    color_scheme,
                    count,
                    fn prior_count -> count + prior_count end
                  )
                else
                  suffix_counts
                end
              end
            end)
      end
    end


  end
end
