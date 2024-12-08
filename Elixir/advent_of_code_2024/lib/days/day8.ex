defmodule Days.Day8 do
  defstruct []

  defimpl DaySolver do
    @typep height() :: pos_integer()
    @typep width() :: pos_integer()
    @typep map_dimensions() :: {height(), width()}
    @typep position() :: {non_neg_integer(), non_neg_integer()}
    @typep frequency() :: String.t()
    @typep antennas() :: %{frequency() => MapSet.t(position())}
    @typep day_input() :: {map_dimensions(), antennas()}

    @spec parse_input(%Days.Day8{}, String.t()) :: day_input()
    def parse_input(_day_solver, input_text) do
      lines = input_text |>
        String.split(~r"\r?\n") |>
        Enum.reject(fn line -> String.match?(line, ~r"^\s*$") end)
      dimensions = parse_map_dimensions(lines)
      antennas = parse_antennas(lines)
      {dimensions, antennas}
    end

    @spec parse_map_dimensions(list(String.t())) :: map_dimensions()
    defp parse_map_dimensions(lines) do
      height = Enum.count(lines)
      width = String.length(hd(lines))
      {height, width}
    end

    @spec parse_antennas(list(String.t())) ::antennas()
    defp parse_antennas(lines) do
      rejected_letters = MapSet.new(["."])
      lines |>
      Enum.with_index() |>
      Enum.reduce(%{}, fn {line, y}, positions ->
        line |>
          String.graphemes() |>
          Enum.with_index() |>
          Enum.reduce(positions, fn {letter, x}, positions ->
            if MapSet.member?(rejected_letters, letter) do
              positions
            else
              Map.update(
                positions,
                letter,
                MapSet.new([{y, x}]),
                fn posses -> MapSet.put(posses, {y, x}) end
              )
            end
          end)
      end)
    end


    @spec solve_part1(%Days.Day8{}, day_input()) :: String.t()
    def solve_part1(_day_solver, input) do
      {dimensions, antennas} = input
      antennas |>
        Map.values() |>
        Enum.map(fn antennas_for_frequency ->
          antinodes_for_frequency(antennas_for_frequency, dimensions)
        end) |>
        Enum.reduce(&MapSet.union/2) |>
        Enum.count() |>
        to_string()
    end

    @spec antinodes_for_frequency(MapSet.t(position()), map_dimensions()) :: MapSet.t(position())
    defp antinodes_for_frequency(antennas_with_frequency, dimensions) do
      antennas_with_frequency |>
        Enum.flat_map(fn base_antenna->
          antennas_with_frequency |>
            Enum.flat_map(fn other_antenna ->
              directed_antinodes_for_antenna_pair(base_antenna, other_antenna)
            end)
        end) |>
        Enum.filter(fn antenna -> on_map?(antenna, dimensions) end) |>
        MapSet.new()
    end

    @spec on_map?(position(), map_dimensions()) :: boolean()
    defp on_map?({y, x}, {height, width}) do
      y >= 0 and y < height and x >= 0 and x < width
    end

    @spec directed_antinodes_for_antenna_pair(position(), position()):: list(position())
    defp directed_antinodes_for_antenna_pair(base_antenna, other_antenna) do
      if base_antenna == other_antenna do
        []
      else
        {y_b, x_b} = base_antenna
        {y, x} = other_antenna
        {y_diff, x_diff} = {y - y_b, x - x_b}
        guaranteed_antinode = {y + y_diff, x + x_diff}
        if rem(y_diff, 3) == 0 and rem(x_diff, 3) == 0 do
          inner_antinode = {y - floor(y_diff / 3), x - floor(x_diff / 3)}
          [guaranteed_antinode, inner_antinode]
        else
          [guaranteed_antinode]
        end
      end
    end

    @spec solve_part2(%Days.Day8{}, day_input()) :: String.t()
    def solve_part2(_day_solver, input) do

      {dimensions, antennas} = input
      antennas |>
        Map.values() |>
        Enum.map(fn antennas_for_frequency ->
          resonant_antinodes_for_frequency(antennas_for_frequency, dimensions)
        end) |>
        Enum.reduce(&MapSet.union/2) |>
        Enum.count() |>
        to_string()
    end

    @spec resonant_antinodes_for_frequency(MapSet.t(position()), map_dimensions()) :: MapSet.t(position())
    defp resonant_antinodes_for_frequency(antennas_with_frequency, dimensions) do
      antennas_with_frequency |>
        Enum.flat_map(fn base_antenna->
          antennas_with_frequency |>
            Enum.flat_map(fn other_antenna ->
              resonant_antinodes_for_antenna_pair(base_antenna, other_antenna, dimensions)
            end)
        end) |>
        MapSet.new()
    end

    @spec resonant_antinodes_for_antenna_pair(position(), position(), map_dimensions()):: list(position())
    defp resonant_antinodes_for_antenna_pair(base_antenna, other_antenna, {height, width}) do
      if base_antenna == other_antenna do
        []
      else
        {y_b, x_b} = base_antenna
        {y, x} = other_antenna
        cond do
          x == x_b ->
            Range.new(0, height - 1) |>
              Enum.map(fn y_r -> {y_r, x} end)
          y == y_b ->
            Range.new(0, width - 1) |>
              Enum.map(fn x_r -> {y, x_r} end)
          true ->
            {y_diff, x_diff} = {y - y_b, x - x_b}
            gcd = Integer.gcd(y_diff, x_diff)
            {y_step, x_step} = if y_diff < 0 do
              {-floor(y_diff / gcd), -floor(x_diff / gcd)}
            else
              {floor(y_diff / gcd), floor(x_diff / gcd)}
            end
            steps = Range.new(-floor(y / y_step), floor((height-y-1)/y_step))
            steps |>
              Enum.map(fn step -> {y + step * y_step, x + step * x_step} end) |>
              Enum.filter(fn {_, x_n} -> x_n >= 0 and x_n < width end)
        end
      end
    end

  end
end
