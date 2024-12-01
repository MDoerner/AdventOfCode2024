defmodule Days.Day1 do
  defstruct []

  defimpl DaySolver do
    @typep day_input() :: {list(integer()), list(integer())}

    @spec parse_input(%Days.Day1{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      input_text |>
      String.split(~r"\r?\n") |>
      Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end) |>
      Enum.map(fn line -> line |>
                                  String.split(~r"\s+") |>
                                  Enum.map(fn number_text -> String.to_integer(number_text) end) |>
                                  List.to_tuple
               end) |>
      Enum.unzip()
    end

    @spec solve_part1(%Days.Day1{},day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {list1, list2} = input
      sorted1 = Enum.sort(list1)
      sorted2 = Enum.sort(list2)
      Enum.zip(sorted1, sorted2) |>
        Enum.map(fn {a, b} -> abs(a - b) end) |>
        Enum.sum()
    end


    @spec solve_part2(%Days.Day1{},day_input()) :: String.t()
    def solve_part2(_day_solver, input) do
      {left_ids, right_ids} = input
      right_frequencies = Enum.frequencies(right_ids)
      left_ids |>
        Enum.map(fn location_id -> similarity_score(location_id, right_frequencies) end) |>
        Enum.sum()
    end

    @spec similarity_score([integer()], %{integer() => integer()}) :: integer()
    defp similarity_score(location_id, reference_frequencies) do
      location_id * Map.get(reference_frequencies, location_id, 0)
    end


  end
end
